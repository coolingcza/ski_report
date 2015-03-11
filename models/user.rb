# Class: User
#
# Models a user with relevant attributes.
#
# Attributes:
# @name    - String: user's name.
# @id      - Number: primary key in users table.

class User < ActiveRecord::Base
  
  has_and_belongs_to_many :resorts, join_table: :users_resorts
  
end