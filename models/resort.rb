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

class Resort < ActiveRecord::Base
  
  has_and_belongs_to_many :users, join_table: :users_resorts

  
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
    #results = DATABASE.execute("SELECT DISTINCT state FROM resorts")
    results = self.select(:state).distinct
  end
  
  # Public: #delete_resort_users
  # Removes records from users_resorts join table.
  #
  # Parameters:
  # none
  #
  # Returns:
  # empty array
  #
  # State Changes:
  # Join table modified.
  
  def delete_resort_users
    users.delete
  end
  
end
