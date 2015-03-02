# Class: MapString
#
# Models a map string.
#
# Attributes:
# @marker_strings - Array: initially empty.
# @url            - String: url to send to Google Static Maps API.
#
# Public Methods:
# #add_type_marker
# #add_prob_marker
# #add_accum_marker
# #generate_map_url
#
# Private Methods:
# #label_and_location

class WxData
  
  attr_reader :map_strings, :temp_chart_data, :wind_speed_chart_data, :cloud_cover_chart_data
  
  def initialize
    @map_strings  = {}
    days_setup
    
    @temp_chart_data = []
    @wind_speed_chart_data = []
    @cloud_cover_chart_data = []
  end
  
  def day_data
    {
      "type" => MapString.new,
      "accum" => MapString.new,
      "prob" => MapString.new
    }
  end
  
  def days_setup
    for i in 0..3
      @map_strings.store("#{i}", day_data)
    end
    @map_strings
  end
  
  def build_map_strings(forecast_daily_data,resort)
    
    @map_strings.each do |day,params|
      f = forecast_daily_data[day.to_i]
      
      params["type"].add_type_marker(f["precipType"],resort)
      params["accum"].add_accum_marker(f["precipAccumulation"],resort)
      params["prob"].add_prob_marker(f["precipProbability"],resort)

    end
  end
  
  def generate_map_urls
    @map_strings.each do |day,params|
      params.each do |parameter,mapstring|
        mapstring.generate_map_url
      end
    end
  end
  
  def build_chart_series(forecast_hourly_data,resort)
    t_series = ChartData.new(resort.name)
    ws_series = ChartData.new(resort.name)
    cc_series = ChartData.new(resort.name)

    # add hourly data points
    for i in 0..48
      h = forecast_hourly_data[i]
      tm = Time.at(h["time"])
  
      t_series.add_data_point([tm, h["temperature"]])
      ws_series.add_data_point([tm, h["windSpeed"]])
      cc_series.add_data_point([tm, h["cloudCover"]*100])
  
    end
    
    @temp_chart_data << {name: t_series.name, data: t_series.data}
    @wind_speed_chart_data << {name: ws_series.name, data: ws_series.data}
    @cloud_cover_chart_data << {name: cc_series.name, data: cc_series.data}
  end
  
end