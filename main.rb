require "forecast_io"
require "faraday"
require "pry"
require "SQLite3"
require "sinatra"
require "chartkick"

DATABASE = SQLite3::Database.new('database/powder_report.db')

require_relative "database/database_setup"
require_relative "database/database_methods"
require_relative "models/user"
require_relative "models/resort"
require_relative "models/marker"



ForecastIO.api_key = '1e01b6795e84c5bade0cddcf3772380c'



get "/" do
  erb :welcome, :layout => :boilerplate
end

get "/user_sign_in" do
  
  user = User.where_name(params["username"])
  
  if user.length == 0
    redirect to("/new_user?username=#{params["username"]}")
  else
    redirect to("/display?username=#{params["username"]}")
  end
  
end

get "/new_user" do
  @path = request.path_info
  
  @state_list = []
  array_results = Resort.get_states
  array_results.each { |a| @state_list << a["state"] }
  
  @state = params["state"]
  @username = params["username"]
  @var_text = "Hello, new user: #{params["username"]}"
  
  if @state
    @resort_list = Resort.where_attr("resorts","state",@state)
  end
  
  erb :select_resorts, :layout => :boilerplate
  
end
  

get "/change_resorts" do
  
  @state_list = []
  array_results = Resort.get_states
  array_results.each { |a| @state_list << a["state"] }
  
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
  @user.delete_user_resorts(@user.id)
  
  erb :select_resorts, :layout => :boilerplate
  
end


before "/display" do
  #source = request.referrer
  
  new_user_test = User.where_name(params["username"])
  
  if new_user_test.length == 0
    @user = User.new({"name"=>params["username"]})
    @user.insert
    
    params.reject!{ |k,v| k == "username" }
    
    if params.length > 6
      if params["state"]
        redirect to("/change_resorts?username=#{@user.name}&state=#{params["state"]}&surfeit=yes")
      else
        redirect to("/change_resorts?username=#{@user.name}&surfeit=yes")
      end
    end

    params.each do |r,y| #each resort
      resort = Resort.where_name(r)[0] #generate resort object
      @user.insert_user_resort(@user.id,resort.id)
    end
    
    user_resorts = @user.get_user_resorts(@user.id)
    
  else
    
    @user = new_user_test[0]
    @state = params["state"]
    params.reject!{ |k,v| k == "username" || k == "state" }
    
    user_resorts = @user.get_user_resorts(@user.id) #array of hashes
    
    if user_resorts.length == 0 #if user has no resorts in bridge table
    
      if params.length > 6
        if @state
          redirect to("/change_resorts?username=#{@user.name}&state=#{@state}&surfeit=yes")
        else
          redirect to("/change_resorts?username=#{@user.name}&surfeit=yes")
        end
      elsif params.length == 0
        if @state
          redirect to("/change_resorts?username=#{@user.name}&state=#{@state}&dearth=yes")
        else
          redirect to("/change_resorts?username=#{@user.name}&&dearth=yes")
        end
      end
    
      params.each do |r,y| #each resort
        resort = Resort.where_name(r)[0] #generate resort object
        @user.insert_user_resort(@user.id,resort.id)
      end
      
      user_resorts = @user.get_user_resorts(@user.id)
      
    end

    
  end
  
  @username = @user.name
  
  forecasts = {}
  map_markers = {
    "0" => {
      "prob" => [],
      "type" => [],
      "accum" => []
    },
    "1" => {
      "prob" => [],
      "type" => [],
      "accum" => []
    },
    "2" => {
      "prob" => [],
      "type" => [],
      "accum" => []
    },
    "3" => {
      "prob" => [],
      "type" => [],
      "accum" => []
    }
  }
  
  @map_strings = map_markers
  
  @resorts = []
  
  user_resorts.each do |r|
    resort = Resort.find("resorts",r["resort_id"])
    @resorts << resort

    forecast = ForecastIO.forecast(resort.latitude, resort.longitude, options = {params: {exclude: 'currently,minutely,hourly,flags' }} )
    
    wx_cond = {
      time: [],
      p_type: [],
      p_accumulation: [],
      p_probability: [],
      t_min: [],
      t_max: [],
      wind_speed: [],
      cloud_cover: []
    }
    
    for i in 0..3
      d = forecast["daily"]["data"][i]
      
      wx_cond[:time] << Time.at(d["time"])
      
      wx_cond[:p_type] << d["precipType"]
      if d["precipType"]=="snow"
        m = Marker.find("markers",1)
      elsif d["precipType"]=="rain"
        m = Marker.find("markers",2)
      elsif d["precipType"]=="sleet"
        m = Marker.find("markers",12)
      else
        m = Marker.find("markers",3)
      end
      string = "color:0x"+m.description+"%7Clabel:#{resort.name[0..0]}%7C"+resort.latitude.to_s+","+resort.longitude.to_s
      map_markers["#{i}"]["type"] << string
      
      #color:0xFFFF00%7C62.107733,-145.541936
      wx_cond[:p_accumulation] << d["precipAccumulation"]
      if !d["precipAccumulation"]
        m = Marker.find("markers",4)
      elsif d["precipAccumulation"] > 0 && d["precipAccumulation"] < 2
        m = Marker.find("markers",5)
      elsif d["precipAccumulation"] >= 2 && d["precipAccumulation"] < 6
        m = Marker.find("markers",6)
      else
        m = Marker.find("markers",7)
      end
      string = "color:0x"+m.description+"%7Clabel:#{resort.name[0..0]}%7C"+resort.latitude.to_s+","+resort.longitude.to_s
      map_markers["#{i}"]["accum"] << string
      
      wx_cond[:p_probability] << d["precipProbability"]
      if d["precipProbability"]==0
        m = Marker.find("markers",8)
      elsif d["precipProbability"] > 0 && d["precipProbability"] < 0.5
        m = Marker.find("markers",9)
      elsif d["precipProbability"] >= 0.5 && d["precipProbability"] < 0.75
        m = Marker.find("markers",10)
      elsif d["precipProbability"] >= 0.75 && d["precipProbability"] <= 1.0
        m = Marker.find("markers",11)
      end
      string = "color:0x"+m.description+"%7Clabel:#{resort.name[0..0]}%7C"+ resort.latitude.to_s+","+resort.longitude.to_s
      map_markers["#{i}"]["prob"] << string
      
      wx_cond[:t_min] << d["temperatureMin"]
      wx_cond[:t_max] << d["temperatureMax"]
      wx_cond[:wind_speed] << d["windSpeed"]
      wx_cond[:cloud_cover] << d["cloudCover"]
    end
    
    forecasts["#{resort.name}"] = wx_cond

  end
    
  
  #generate google maps strings - populate hash
  
  string_base = "https://maps.googleapis.com/maps/api/staticmap?"
  size = "size=225x150"
  maptype = "&maptype=terrain"
  markers_start = "&markers="
  
  for i in 0..3
    map_markers["#{i}"].each do |j,k|
      marker_string = k.join("&markers=")
      @map_strings["#{i}"]["#{j}"] = string_base+size+maptype+markers_start+marker_string
    end
  end
  
  #fill marker list for legends
  @markers = Marker.all("markers") #array of objs
  
  #create arrays for chart data
  @temp_min_chart_data = []
  @temp_max_chart_data = []
  @wind_speed_chart_data = []
  @cloud_cover_chart_data = []
  
  #populate chart data arrays
  forecasts.each do |k,v|
    #for each resort start hash
    resort_hash_tmin = {name: k, data:[]}
    resort_hash_tmax = {name: k, data:[]}
    resort_hash_windspeed = {name: k, data:[]}
    resort_hash_cloudcover = {name: k, data:[]}
    for i in 0..3
      resort_hash_tmin[:data] << [v[:time][i],v[:t_min][i]]
      resort_hash_tmax[:data] << [v[:time][i],v[:t_max][i]]
      resort_hash_windspeed[:data] << [v[:time][i],v[:wind_speed][i]]
      resort_hash_cloudcover[:data] << [v[:time][i],v[:cloud_cover][i]*100]
    end
    @temp_min_chart_data << resort_hash_tmin
    @temp_max_chart_data << resort_hash_tmax
    @wind_speed_chart_data << resort_hash_windspeed
    @cloud_cover_chart_data << resort_hash_cloudcover
  end
 
  #binding.pry
  
end

get "/display" do
  erb :display, :layout => :boilerplate
end


#binding.pry