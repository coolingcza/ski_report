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

module Marker #< ActiveRecord::Base
  
  # attr_accessor :marker_strings
  # attr_reader :url
  
  # Public: .
  # Gets a list of users with the given name.
  #
  # Parameters:
  # x - String: The name to search for.
  #
  # Returns: Array containing objects for matching user records.
  
  def get_pcp_type_description(x) #self.
    if x == "snow"
      m_hex = "0066CC" #Marker.find(1).description
    elsif x == "rain"
      m_hex = "00CC00" #Marker.find(2).description
    elsif x == "sleet"
      m_hex = "FF66FF" #Marker.find(12).description
    else
      m_hex = "A0A0A0" #Marker.find(3).description
    end
    m_hex
  end
  
  
  def get_pcp_accum_description(x) #self.
    if x == nil
      m_hex = "A0A0A0" #Marker.find(4).description
    elsif x > 0 && x < 2
      m_hex = "66B2FF" #Marker.find(5).description
    elsif x >= 2 && x < 6
      m_hex = "0080FF" #Marker.find(6).description
    elsif x >= 6
      m_hex = "004C99" #Marker.find(7).description
    end
    m_hex
  end
  
  
  def get_pcp_prob_description(x) #self.
    if x==0
      m_hex = "C0C0C0" #Marker.find(8).description
    elsif x > 0 && x < 0.5
      m_hex = "99FF99" #Marker.find(9).description
    elsif x >= 0.5 && x < 0.75
      m_hex = "00FF00" #Marker.find(10).description
    elsif x >= 0.75 && x <= 1.0
      m_hex = "009900" #Marker.find(11).description
    end
    m_hex
  end
  
end

# id   condition     description
# ---  ------------  ------------
# 1    snow          0066CC
# 2    rain          00CC00
# 3    nil           A0A0A0
# 4    accum0        A0A0A0
# 5    accum0t2      66B2FF
# 6    accum2t6      0080FF
# 7    accumgt6      004C99
# 8    pprob0        C0C0C0
# 9    pproblt50     99FF99
# 10   pproblt75     00FF00
# 11   pproblt1      009900
# 12   sleet         FF66FF