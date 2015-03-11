get "/admin" do
  #binding.pry
  @state_list = []
  Resort.get_states.each { |a| @state_list << a["state"] }
  
  @resorts = Resort.all#("resorts")
  @user_list = User.all#("users")
  @change = true if session[:admin_change]
  
  if @change
    if session[:admin_change].has_key?("newresort")
      @newresort = Resort.find(session[:admin_change]["newresort"])
      #@newresort = Resort.find("resorts",session[:admin_change]["newresort"])
      @resorts = Resort.all#("resorts")
      @display = :add
    
    elsif session[:admin_change].has_key?("delresort")
      @delresort = session[:admin_change]["delresort"]
      @resorts = Resort.all#("resorts")
      @display = :rem_res
    
    elsif session[:admin_change].has_key?("updresort")
      @updresort = Resort.find(session[:admin_change]["updresort"][0])
      #@updresort = Resort.find("resorts",session[:admin_change]["updresort"][0])
      @old_name = session[:admin_change]["updresort"][1]
      @resorts = Resort.all#("resorts")
      @display = :upd
    
    elsif session[:admin_change].has_key?("display")
      @display = :dis
    
    elsif session[:admin_change].has_key?("deluser")
      @rem_user_name = session[:admin_change]["deluser"]
      @user_list = User.all#("users")
      @display = :rem_usr
    end
  end
  
  erb :"admin_routes/admin", :layout => :boilerplate
  
end

post "/admin/add_resort" do
  if Resort.where({"name" => params["addresortname"]}).length == 0
    
  #if Resort.where_name(params["addresortname"]).length == 0
    
    newresort = Resort.new ({
      "name" => params["addresortname"],
      "latitude" => params["latitude"].to_f,
      "longitude" => params["longitude"].to_f,
      "state" => params["state"]
    })
    
    # newresort = Resort.new do |r|
    #   r.name = params["addresortname"]
    #   r.latitude = params["latitude"].to_f
    #   r.longitude = params["longitude"].to_f
    #   r.state = params["state"]
    # end
    
    # user = User.new do |u|
    #   u.name = "David"
    #   u.occupation = "Code Artist"
    # end
    
    binding.pry
    newresort.save
    session[:admin_change] = {"newresort" => newresort.id}
    redirect to("/admin")
  else
    #send back with error message
  end
end

post "/admin/remove_resort" do
  # delresort = Resort.find("resorts",params["delresortid"])
  delresort = Resort.find(params["delresortid"])
  delresort.delete
  delresort.delete_resort_users
  session[:admin_change] = {"delresort" => delresort.name}
  redirect to("/admin")
end

post "/admin/update_resort" do
  updresort = Resort.find("resorts",params["updresortid"])
  old_name = updresort.name
  updresort.name = params["newresortname"]
  updresort.save
  session[:admin_change] = {"updresort" => [updresort.id,old_name]}
  redirect to("/admin")
end

post "/admin/remove_user" do
  deluser = User.find("users",params["deluserid"])
  deluser.delete
  deluser.delete_user_resorts
  session[:admin_change] = {"deluser" => deluser.name}
  redirect to("/admin")
end

post "/admin/display_resorts" do
  session[:admin_change] = {"display" => true}
  redirect to("/admin")
end