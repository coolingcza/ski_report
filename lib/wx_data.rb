# Class: WxData
#
# Processes weather forecast data into structures for display APIs.
#
# Attributes:
# @map_strings            - Hash: initially empty.
# @temp_chart_data        - Array: initially empty.
# @wind_speed_chart_data  - Array: initially empty.
# @cloud_cover_chart_data - Array: initially empty.
#
# Public Methods:
# #build_map_strings
# #generate_map_urls
# #build_chart_series
#
# Private Methods:
# #day_data
# #days_setup

class WxData
  
  attr_reader :map_strings, :temp_chart_data, :wind_speed_chart_data, :cloud_cover_chart_data
  
  def initialize
    @map_strings  = {}
    days_setup
    
    @temp_chart_data = []
    @wind_speed_chart_data = []
    @cloud_cover_chart_data = []
  end
  
  # Public: #build_marker_strings
  # Adds resort marker string to precip type MarkerStrings.
  #
  # Parameters:
  # @forecast_daily_data
  # @resort
  #
  # Returns: populated @map_strings.
  #
  # State Changes: value added to MapString @marker_strings array.
  
  def build_marker_strings(forecast_daily_data,resort)
    
    @map_strings.each do |day,params|
      f = forecast_daily_data[day.to_i]
      
      params["type"].add_type_marker(f["precipType"],resort)
      params["accum"].add_accum_marker(f["precipAccumulation"],resort)
      params["prob"].add_prob_marker(f["precipProbability"],resort)

    end
  end
  
  # Public: #generate_map_urls
  # Combines MapString @marker_strings into map URL.
  #
  # Parameters:
  # none.
  #
  # Returns: ?
  #
  # State Changes: Sets MapString @url.
  
  def generate_map_urls
    @map_strings.each do |day,params|
      params.each do |parameter,mapstring|
        mapstring.generate_map_url
      end
    end
  end
  
  # Public: #build_chart_series
  # Populates chart data arrays with resort series hashes.
  #
  # Parameters:
  # @forecast_hourly_data
  # @resort
  #
  # Returns: ?
  #
  # State Changes: Hash added to each chart data array.
  
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
  
  
  private
  
  # Private: #day_data
  # Returns hash data structure with precip type MapStrings.
  #
  # Parameters:
  # none.
  #
  # Returns: Hash with precipitation type MapStrings.
  
  def day_data
    {
      "type" => MapString.new,
      "accum" => MapString.new,
      "prob" => MapString.new
    }
  end
  
  # Private: #days_setup
  # Fills @map_strings Hash with three day_data structures.
  #
  # Parameters:
  # none.
  #
  # Returns: populated @map_strings.
  
  def days_setup
    for i in 0..3
      @map_strings.store("#{i}", day_data)
    end
    @map_strings
  end
  
end