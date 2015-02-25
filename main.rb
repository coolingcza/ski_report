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
require_relative "lib/map_string"
require_relative "lib/chart_data"
require_relative "controllers/admin"
require_relative "controllers/user"



ForecastIO.api_key = '1e01b6795e84c5bade0cddcf3772380c'











