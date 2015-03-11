# Class: Marker
#
# Models a map marker with relevant attributes.
#
# Attributes:
# @id          - Number: primary key in markers table.
# @condition   - String: weather condition represented by marker
# @description - marker representation description for Google Static Maps API
#
# Public Methods:
# none

class Marker < ActiveRecord::Base
  
  # Public: .where_name
  # Gets a list of users with the given name.
  #
  # Parameters:
  # x - String: The name to search for.
  #
  # Returns: Array containing objects for matching user records.
  
  def self.get_pcp_type_description(x)
    if x == "snow"
      m_hex = Marker.find(1).description
    elsif x == "rain"
      m_hex = Marker.find(2).description
    elsif x == "sleet"
      m_hex = Marker.find(12).description
    else
      m_hex = Marker.find(3).description
    end
    m_hex
  end
  
  
  def self.get_pcp_accum_description(x)
    if x == nil
      m_hex = Marker.find(4).description
    elsif x > 0 && x < 2
      m_hex = Marker.find(5).description
    elsif x >= 2 && x < 6
      m_hex = Marker.find(6).description
    elsif
      m_hex = Marker.find(7).description
    end
    m_hex
  end
  
  
  def self.get_pcp_prob_description(x)
    if x==0
      m_hex = Marker.find(8).description
    elsif x > 0 && x < 0.5
      m_hex = Marker.find(9).description
    elsif x >= 0.5 && x < 0.75
      m_hex = Marker.find(10).description
    elsif x >= 0.75 && x <= 1.0
      m_hex = Marker.find(11).description
    end
    m_hex
  end
  
end