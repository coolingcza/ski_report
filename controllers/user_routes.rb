enable :sessions

get "/" do
  erb :"user_routes/welcome", :layout => :boilerplate
end


post "/user_sign_in" do
  session[:username] = params["username"]
  
  if User.exists?(session[:username])
    user = User.where_name(session[:username])[0]
    session[:user_id] = user.id
  else
    user = User.new({"name"=>session[:username]})
    user.insert
    session[:user_id] = user.id
  end
  
  if user.has_resorts?
    redirect to("/display")
  else
    redirect to("/select_resorts")
  end
end


get "/select_resorts" do
  @state_list = []
  Resort.get_states.each { |a| @state_list << a["state"] }

  @state = session[:state]
  
  if params["surfeit"] 
    @surfeit_text = "Too many resorts selected.  Please select six or fewer."
  end
  
  if @state
    @resort_list = Resort.where_attr("resorts","state",@state)
  end
  
  erb :"user_routes/select_resorts", :layout => :boilerplate
end


post "/set_state" do
  session[:state] = params["state"]
  redirect to("/select_resorts")
end


post "/change_resorts" do
  # check params for number of resorts
  if params.length > 6
    redirect to("/select_resorts?surfeit=yes")
  elsif params.length == 0
    redirect to("/select_resorts")
  else
    # delete existing user resorts
    user = User.find("users",session[:user_id])
    user.delete_user_resorts
    # add new user resorts
    params.each do |r,n|
      resort = Resort.find("resorts",r)
      user.insert_user_resort(resort.id)
    end
    redirect to("/display")
  end
end


before "/display" do
  @user = User.find("users",session[:user_id])
  @user_resorts = @user.get_user_resorts
  
  @data = WxData.new()
  @resorts = []
  
  @user_resorts.each do |r|
    resort = Resort.find("resorts",r["resort_id"])
    @resorts << resort

    forecast = ForecastIO.forecast(resort.latitude, resort.longitude, \
              options = {params: {exclude: 'currently,minutely,flags,alerts'}})

    @data.build_marker_strings(forecast["daily"]["data"],resort)
    @data.build_chart_series(forecast["hourly"]["data"],resort)
    
  end
  
  @data.generate_map_urls
  
  #fill marker list for legends
  @markers = Marker.all("markers")
  
end

get "/display" do
  erb :"user_routes/display", :layout => :boilerplate
end
