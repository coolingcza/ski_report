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
    @state = params["state"]
    
    params.reject!{ |k,v| k == "username" || k == "state" }
    
    if params.length > 6
      if @state
        redirect to("/change_resorts?username=#{@user.name}&state=#{@state}&surfeit=yes")
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
          redirect to("/change_resorts?username=#{@user.name}&dearth=yes")
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
  forecasts_hourly = {}
  
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

    forecast = ForecastIO.forecast(resort.latitude, resort.longitude, options = {params: {exclude: 'currently,minutely,flags,alerts' }} )
    
    pcp_cond = {
      time: [],
      p_type: [],
      p_accumulation: [],
      p_probability: [],
    }
    
    
    for i in 0..3
      d = forecast["daily"]["data"][i]
      
      pcp_cond[:time] << Time.at(d["time"])
      
      pcp_cond[:p_type] << d["precipType"]
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
      pcp_cond[:p_accumulation] << d["precipAccumulation"]
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
      
      pcp_cond[:p_probability] << d["precipProbability"]
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

    end
    
    forecasts["#{resort.name}"] = pcp_cond

    resort_hourly = { 
      temp_data: [],
      wind_speed_data: [],
      cloud_cover_data: []
    }
    
    for i in 0..48
      h = forecast["hourly"]["data"][i]
      tm = Time.at(h["time"])
      
      resort_hourly[:temp_data] << [tm, h["temperature"]]
      resort_hourly[:wind_speed_data] << [tm, h["windSpeed"]]
      resort_hourly[:cloud_cover_data] << [tm, h["cloudCover"]*100]
      
    end

    forecasts_hourly["#{resort.name}"] = resort_hourly
    
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
  @temp_chart_data = []
  @wind_speed_chart_data = []
  @cloud_cover_chart_data = []
  
  #populate chart data arrays
  forecasts_hourly.each do |k,v|
    @temp_chart_data << {name: k, data: v[:temp_data]}
    @wind_speed_chart_data << {name: k, data: v[:wind_speed_data]}
    @cloud_cover_chart_data << {name: k, data: v[:cloud_cover_data]}
  end

  
end

get "/display" do
  erb :display, :layout => :boilerplate
end



get "/admin" do
  @state_list = []
  array_results = Resort.get_states
  array_results.each { |a| @state_list << a["state"] }
  
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
      @deluser.delete_user_resorts(@deluser.id)
      @user_list = User.all("users")
      @display = :rem_usr
    end
  end
  
  erb :admin, :layout => :boilerplate
  
end

