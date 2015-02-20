# Class: User
#
# Models a user with relevant attributes.
#
# Attributes:
# @name    - String: user's name.
# @id      - Number: primary key in people table.
# @table   - String: "people"
#
# Public Methods:
# #where_name

class User
  
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id, :table
  attr_accessor :name
  
  # Public: .where_name
  # Gets a list of users with the given name.
  #
  # Parameters:
  # x - String: The name to search for.
  #
  # Returns: Array containing objects for matching user records.
  
  def self.where_name(x)
    results = DATABASE.execute("SELECT * FROM users WHERE name = '#{x}'")

    results_as_objects = []

    results.each do |r|
      results_as_objects << self.new(r)
    end

    results_as_objects
  end
  
  
  def initialize(options)
    @id      = options["id"]
    @name    = options["name"]
    @table   = "users"
  end
  
  # Public: insert_user_resort
  # Inserts a record into the users_resorts bridge table.
  #
  # Parameters:
  # user_id   - Number: ID associated with user record in users table.
  # resort_id - Number: ID associated with resort record in resorts table.
  #
  # Returns: none.
  
  def insert_user_resort(user_id,resort_id)
      
    DATABASE.execute("INSERT INTO users_resorts (user_id, resort_id) VALUES (#{user_id}, #{resort_id})")
    
  end
  
  # Public: get_user_resorts
  # Selects records in bridge table associated with a given user ID.
  #
  # Parameters:
  # user_id - Number: ID associated with user record in users table.
  #
  # Returns: Array of hashes containing bridge table records.
  
  def get_user_resorts(user_id)
    DATABASE.execute("SELECT resort_id FROM users_resorts WHERE user_id = #{user_id}")
  end
  
  # Public: delete_user_resorts
  # Deletes records in bridge table associated with a given user ID.
  #
  # Parameters:
  # user_id - Number: ID associated with user record in users table.
  #
  # Returns: none.
  
  def delete_user_resorts(user_id)
    DATABASE.execute("DELETE FROM users_resorts WHERE user_id = #{user_id}")
  end
  
end