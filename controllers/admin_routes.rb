get "/admin" do
  @state_list = []
  Resort.get_states.each { |a| @state_list << a["state"] }
  
  @resorts = Resort.all("resorts")
  @user_list = User.all("users")
  @change = true if params["change"]
  
  if @change
    if params["addresortname"]
      if Resort.where_name(params["addresortname"]).length == 0
        @newresort = Resort.new({
          "name" => params["addresortname"],
          "latitude" => params["latitude"].to_f,
          "longitude" => params["longitude"].to_f,
          "state" => params["state"]
          })
        @newresort.insert
        @resorts = Resort.all("resorts")
      end
      @display = :add
      
    elsif params["delresortid"]
      @delresort = Resort.find("resorts",params["delresortid"])
      @delresort.delete
      #needs to clean up bridge table as well
      @display = :rem_res
      @resorts = Resort.all("resorts")
      
    elsif params["newresortname"]
      @updresort = Resort.find("resorts",params["updresortid"])
      @old_name = @updresort.name
      @updresort.name = params["newresortname"]
      @updresort.save
      @display = :upd
      @resorts = Resort.all("resorts")
      
    elsif params["display"]
      @display = :dis
      
    elsif params["deluserid"]
      @deluser = User.find("users",params["deluserid"])
      @deluser.delete
      @deluser.delete_user_resorts
      @user_list = User.all("users")
      @display = :rem_usr
    end
  end
  
  erb :"admin/admin", :layout => :boilerplate
  
end