require 'rubygems'
require 'bundler/setup'

# replaced require gem statements with: 
Bundler.require(:default)

configure :development do
 set :database, {adapter: "sqlite3", database: "database/powder_report.db"}
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'])
 ActiveRecord::Base.establish_connection(
 :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
 :host => db.host,
 :username => db.user,
 :password => db.password,
 :database => db.path[1..-1],
 :encoding => 'utf8'
 )
end

require_relative "database/database_setup"
require_relative "database/database_methods"
require_relative "models/user"
require_relative "models/resort"
require_relative "models/marker"
require_relative "lib/map_string"
require_relative "lib/chart_data"
require_relative "lib/wx_data"
require_relative "controllers/admin_routes"
require_relative "controllers/user_routes"



ForecastIO.api_key = '1e01b6795e84c5bade0cddcf3772380c'
