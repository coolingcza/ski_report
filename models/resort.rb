# Class: Resort
#
# Models a ski resort.
#
# Attributes:
# @name      - String: resort name.
# @id        - Number: derived from resorts table primary key.
# @latitude  - Number: latitude of resort location
# @longitude - String: longitude of resort location
# @state     - String: state in which resort is located
# 
# Public Methods:
# .get_states

class Resort < ActiveRecord::Base
  
  has_and_belongs_to_many :users #, join_table: :users_resorts
  
  validates :name, :latitude, :longitude, :state, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  
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
