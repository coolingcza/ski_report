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
# .get_states

class Resort < ActiveRecord::Base
  
  has_and_belongs_to_many :users, join_table: :users_resorts
  
  # Public: .get_states
  # Returns the unique values from states field in resorts table.
  #
  # Parameters:
  # none.
  #
  # Returns: Array of hashes {"state" => unique record}. <-probably out of date
  
  def self.get_states
    results = self.select("distinct state")
  end
  
end
