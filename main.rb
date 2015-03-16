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


#seed database tables:

# Resort.create(name: "Breckenridge", latitude: 39.480506, longitude: -106.06688, state: "Colorado")
# Resort.create(name: "Silverton Mountain", latitude: 37.884628, longitude: -107.665708, state: "Colorado")
# Resort.create(name: "Loveland Ski Area", latitude: 39.680273, longitude: -105.895918, state: "Colorado")
# Resort.create(name: "Eldora Mountain Resort", latitude: 39.936816, longitude: -105.58111, state: "Colorado")
# Resort.create(name: "Aspen/Snowmass", latitude: 39.205392, longitude: -106.954583, state: "Colorado")
# Resort.create(name: "Steamboat Resorts", latitude: 40.460842, longitude: -106.801592, state: "Colorado")
# Resort.create(name: "Vail Ski Resort", latitude: 39.606144, longitude: -106.354972, state: "Colorado")
# Resort.create(name: "Winter Park Resort", latitude: 39.882192, longitude: -105.758318, state: "Colorado")
# Resort.create(name: "Monarch Mountain", latitude: 38.512109, longitude: -106.332228, state: "Colorado")
# Resort.create(name: "Ski Cooper", latitude: 39.360208, longitude: -106.301082, state: "Colorado")
# Resort.create(name: "Ski Granby Ranch", latitude: 40.045221, longitude: -105.906196, state: "Colorado")
# Resort.create(name: "Copper Mountain", latitude: 39.478525, longitude: -106.160554, state: "Colorado")
# Resort.create(name: "Telluride Ski Resort", latitude: 37.936549, longitude: -107.846337, state: "Colorado")
# Resort.create(name: "Keystone Resort", latitude: 39.607413, longitude: -105.943595, state: "Colorado")
# Resort.create(name: "Arapahoe Basin Ski Area", latitude: 39.642312, longitude: -105.871685, state: "Colorado")
# Resort.create(name: "Beaver Creek Ski Area", latitude: 39.604429, longitude: -106.516742, state: "Colorado")
# Resort.create(name: "Sunlight Mountain Resort", latitude: 39.39978, longitude: -107.338762, state: "Colorado")
# Resort.create(name: "Wolf Creek", latitude: 37.472082, longitude: -106.793467, state: "Colorado")
# Resort.create(name: "Crested Butte Mountain Resort", latitude: 38.899738, longitude: -106.965817, state: "Colorado")
# Resort.create(name: "Powderhorn Mountain Resort", latitude: 39.069396, longitude: -108.150734, state: "Colorado")
# Resort.create(name: "Durango Mountain Resort", latitude: 37.6290968, longitude: -107.8212715, state: "Colorado")
# Resort.create(name: "White Pass Ski Area", latitude: 46.6360515, longitude: -121.3914783, state: "Washington")
# Resort.create(name: "Bluewood Ski Area", latitude: 46.082494, longitude: -117.851195, state: "Washington")
# Resort.create(name: "Crystal Mountain Resort", latitude: 46.9360365, longitude: -121.474118, state: "Washington")
# Resort.create(name: "Mission Ridge", latitude: 47.292446, longitude: -120.399771, state: "Washington")
# Resort.create(name: "Snowy Range Ski And Recreation Area", latitude: 41.345546, longitude: -106.184176, state: "Wyoming")
# Resort.create(name: "Hogadon Basin Ski Area", latitude: 42.7452436, longitude: -106.3390385, state: "Wyoming")
# Resort.create(name: "Jackson Hole Mountain Resort", latitude: 43.587523, longitude: -110.827849, state: "Wyoming")
# Resort.create(name: "Grand Targhee Resort", latitude: 43.788805, longitude: -110.957839, state: "Wyoming")
# Resort.create(name: "Meadowlark Ski Lodge", latitude: 44.1679002, longitude: -107.2145874, state: "Wyoming")
# Resort.create(name: "White Pine Ski Resort", latitude: 42.977849, longitude: -109.75866, state: "Wyoming")
# Resort.create(name: "Snow King Mountain Resort", latitude: 43.47222, longitude: -110.760742, state: "Wyoming")
                  