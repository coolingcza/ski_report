# Class: Resort
#
# Models a ski resort.
#
# Attributes:
# @name     - String: resort name.
# @id       - Number: derived from resorts table primary key.
# @location - String: latitude,longitude
# @state    - String: state in which resort is located
# @table    - String: "resorts" - name of associated table
# 
# Public Methods:
# #where_name

class Resort
  
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id, :latitude, :longitude, :state, :table
  attr_accessor :name
  
  # Public: .where_name
  # Get a list of resorts with the given name.
  #
  # Parameters:
  # x - String: The name to search for.
  #
  # Returns: Array that contains objects for matching resort records.
  
  def self.where_name(x)
    results = DATABASE.execute("SELECT * FROM resorts WHERE name = '#{x}'")

    results_as_objects = []

    results.each do |r|
      results_as_objects << self.new(r)
    end

    results_as_objects
  end
  
  # Public: .get_states
  # Returns the unique values from states field in resorts table.
  #
  # Parameters:
  # none.
  #
  # Returns: Array of hashes {"state" => unique record}.
  
  def self.get_states
    results = DATABASE.execute("SELECT DISTINCT state FROM resorts")
  end
  
  # Public: #initialize
  # Creates Resort object.
  #
  # Parameters:
  # @name     - String: contains resort name.
  # @id       - Number: derived from resorts table primary key.
  # @location - String: latitude,longitude
  # @state    - String: state in which resort is located
  # @table    - String: "resorts" - name of associated table
  #
  # Returns:
  # Resort object.
  #
  # State Changes:
  # New object created.
  
  def initialize(options)
    @name      = options["name"]
    @id        = options["id"]
    @latitude  = options["latitude"]
    @longitude = options["longitude"]
    @state     = options["state"]
    @table     = "resorts"
  end
  
  def delete_resort_users
    DATABASE.execute("DELETE FROM users_resorts WHERE resort_id = #{@id}")
  end
  
end
