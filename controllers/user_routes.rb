get "/" do
  erb :"user/welcome", :layout => :boilerplate
end



get "/user_sign_in" do
  
  if !User.exists?(params["username"])
    redirect to("/new_user?username=#{params["username"]}")
  else
    redirect to("/display?username=#{params["username"]}")
  end
  
end



get "/new_user" do
  @path = request.path_info
  
  @state_list = []
  Resort.get_states.each { |a| @state_list << a["state"] }
  
  @state = params["state"]
  @username = params["username"]
  @var_text = "Hello, new user: #{params["username"]}"
  
  if @state
    @resort_list = Resort.where_attr("resorts","state",@state)
  end
  
  erb :"user/select_resorts", :layout => :boilerplate
  
end
  


get "/change_resorts" do
  
  @state_list = []
  Resort.get_states.each { |a| @state_list << a["state"] }
  
  @path = request.path_info
  @state = params["state"]
  @username = params["username"]
  
  if params["surfeit"] 
    @var_text = "Too many resorts selected.  Please select six or fewer."
  else
    @var_text = "Hello, #{@username}"
  end
  
  if @state
    @resort_list = Resort.where_attr("resorts","state",@state)
  end
  
  @user = User.where_name(@username)[0]
  @user.delete_user_resorts
  
  erb :"user/select_resorts", :layout => :boilerplate
  
end



before "/display" do #user and resort checks
  
  qs = request.query_string
  
  if User.exists?(params["username"])
    @user = User.where_name(params["username"])[0]
  else
    @user = User.new({"name"=>params["username"]})
    @user.insert
  end
  
  if @user.has_resorts?
    @user_resorts = @user.get_user_resorts
  else
    params.reject!{ |k,v| k == "username" || k == "state" }
    if params.length > 0 && params.length <= 6
      params.each do |r,y|
        resort = Resort.find("resorts",r)
        @user.insert_user_resort(resort.id)
      end
      @user_resorts = @user.get_user_resorts
    elsif params.length == 0
      redirect to("/change_resorts?"+qs)
    else
      redirect to("/change_resorts?"+qs+"&surfeit=yes")
    end
    
  end
  
end

before "/display" do
  
  @map_strings = {
    "0" => { 
      "type" => MapString.new, 
      "accum" => MapString.new, 
      "prob" => MapString.new 
    },
    "1" => { 
      "type" => MapString.new, 
      "accum" => MapString.new, 
      "prob" => MapString.new 
    },
    "2" => { 
      "type" => MapString.new, 
      "accum" => MapString.new, 
      "prob" => MapString.new 
    },
    "3" => { 
      "type" => MapString.new, 
      "accum" => MapString.new, 
      "prob" => MapString.new 
    }
  }
  
  @resorts = []
  
  @temp_chart_data = []
  @wind_speed_chart_data = []
  @cloud_cover_chart_data = []
  
  @user_resorts.each do |r|
    resort = Resort.find("resorts",r["resort_id"])
    @resorts << resort

    forecast = ForecastIO.forecast(resort.latitude, resort.longitude, options = {params: {exclude: 'currently,minutely,flags,alerts'}})
    
    
    # precip markers for maps:
    for i in 0..3
      d = forecast["daily"]["data"][i]
      
      # @map_strings["#{i}"].each do |param,mapstring|
      #   mapstring.set_label_and_location(resort)
      # end
      
      @map_strings["#{i}"]["type"].add_type_marker(d["precipType"],resort)
      @map_strings["#{i}"]["accum"].add_accum_marker(d["precipAccumulation"],resort)
      @map_strings["#{i}"]["prob"].add_prob_marker(d["precipProbability"],resort)

    end
    
    t_series = ChartData.new(resort.name)
    ws_series = ChartData.new(resort.name)
    cc_series = ChartData.new(resort.name)

    # fill hourly chart data
    for i in 0..48
      h = forecast["hourly"]["data"][i]
      tm = Time.at(h["time"])
  
      t_series.add_data_point([tm, h["temperature"]])
      ws_series.add_data_point([tm, h["windSpeed"]])
      cc_series.add_data_point([tm, h["cloudCover"]*100])
  
    end
    
    @temp_chart_data << {name: t_series.name, data: t_series.data}
    @wind_speed_chart_data << {name: ws_series.name, data: ws_series.data}
    @cloud_cover_chart_data << {name: cc_series.name, data: cc_series.data}
    
  end
   
  @map_strings.each do |day,params|
    params.each do |parameter,mapstring|
      mapstring.generate_map_url
    end
  end
  
  #fill marker list for legends
  @markers = Marker.all("markers")

  
end

get "/display" do
  erb :"user/display", :layout => :boilerplate
end
