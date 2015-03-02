# Class: Marker
#
# Models a map marker with relevant attributes.
#
# Attributes:
# @id          - Number: primary key in markers table.
# @condition   - String: weather condition represented by marker
# @description - marker representation description for Google Static Maps API
# @table       - String: "markers"
#
# Public Methods:
# none

class Marker
  
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id, :description
  
  # Public: .where_name
  # Gets a list of users with the given name.
  #
  # Parameters:
  # x - String: The name to search for.
  #
  # Returns: Array containing objects for matching user records.
  
  def self.get_pcp_type_description(x)
    t = "markers"
    if x == "snow"
      m_hex = Marker.find(t,1).description
    elsif x == "rain"
      m_hex = Marker.find(t,2).description
    elsif x == "sleet"
      m_hex = Marker.find(t,12).description
    else
      m_hex = Marker.find(t,3).description
    end
    m_hex
  end
  
  
  def self.get_pcp_accum_description(x)
    t = "markers"
    if x == nil
      m_hex = Marker.find(t,4).description
    elsif x > 0 && x < 2
      m_hex = Marker.find(t,5).description
    elsif x >= 2 && x < 6
      m_hex = Marker.find(t,6).description
    elsif
      m_hex = Marker.find(t,7).description
    end
    m_hex
  end
  
  
  def self.get_pcp_prob_description(x)
    t = "markers"
    if x==0
      m_hex = Marker.find(t,8).description
    elsif x > 0 && x < 0.5
      m_hex = Marker.find(t,9).description
    elsif x >= 0.5 && x < 0.75
      m_hex = Marker.find(t,10).description
    elsif x >= 0.75 && x <= 1.0
      m_hex = Marker.find(t,11).description
    end
    m_hex
  end
  
  def initialize(options)
    @id          = options["id"]
    @condition   = options["condition"]
    @description = options["description"]
    @table       = "markers"
  end
  
end