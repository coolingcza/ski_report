enable :sessions

get "/" do
  erb :"user_routes/welcome", :layout => :boilerplate
end


post "/user_sign_in" do
  session[:username] = params["username"]
  
  if User.exists?({name: session[:username]})
    user = User.find_by_name session[:username] #[0]
    session[:user_id] = user.id
  else
    user = User.create({"name"=>session[:username]})
    session[:user_id] = user.id
  end
  
  if user.resorts.empty?
    redirect to("/select_resorts")
  else
    redirect to("/display")
  end
end


get "/select_resorts" do
  @state_list = Resort.get_states.map { |a| a.state }
  @state = session[:state]
  
  if params["surfeit"] 
    @surfeit_text = "Too many resorts selected.  Please select six or fewer."
  end
  
  if @state
    @resort_list = Resort.where("state = ?", @state)
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
    user = User.find(session[:user_id])
    user.resorts.clear
    # add new user resorts
    params.each do |r,n|
      user.resorts << Resort.find(r)
    end
    redirect to("/display")
  end
end


before "/display" do
  @user = User.find(session[:user_id])
  @user_resorts = @user.resorts
  
  @data = WxData.new()
  
  @user_resorts.each do |r|
    
    forecast = ForecastIO.forecast(r.latitude, r.longitude, \
              options = {params: {exclude: 'currently,minutely,flags,alerts'}})

    @data.build_marker_strings(forecast["daily"]["data"],r)
    @data.build_chart_series(forecast["hourly"]["data"],r)
    
  end
  
  @data.generate_map_urls
  
  #fill marker list for legends
  @markers = Marker.all
  
end

get "/display" do
  erb :"user_routes/display", :layout => :boilerplate
end
