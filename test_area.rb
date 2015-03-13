require "sqlite3"
require "pry"
require "sinatra"
require "sinatra/activerecord"
require "bcrypt"

require_relative "models/user"

set :database, {adapter: "sqlite3", database: "database/powder_report.db"}

user = User.find(1)

password = "fluffy"
#pass_hash = Password.new(password)
pass_hash = BCrypt::Password.create(password)

binding.pry
