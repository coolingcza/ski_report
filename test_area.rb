require "forecast_io"
require "faraday"
require "pry"


#test area to establish access functionality for Forecast_IO API

ForecastIO.api_key = '1e01b6795e84c5bade0cddcf3772380c'



lat = 39.680273
lon = -105.895918

forecast = ForecastIO.forecast(lat, lon, options = {params: {exclude: 'currently,minutely,flags,alerts' }} )

daily = forecast["daily"]["data"]

hourly = forecast["hourly"]["data"]
# time = []
# precip = []
# daily.each do |d|
#   precip << d.precipAccumulation
#   time << Time.at(d.time)
# end

binding.pry

# require "sinatra"
#
# get "/" do
#   erb :welcome, :layout => :boilerplate
# end

