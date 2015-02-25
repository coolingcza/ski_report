# Class: MapString
#
# Models a map string.
#
# Attributes:
# @name    - String: user's name.
# @id      - Number: primary key in people table.
# @table   - String: "people"
#
# Public Methods:
# #where_name

class MapString
  
  attr_accessor :marker_strings
  attr_reader :url
  
  def initialize
    @marker_strings  = []
  end
    
  def label_and_location(resort)
    r_lat = resort.latitude.to_s
    r_lon = resort.longitude.to_s
    "%7Clabel:#{resort.name[0..0]}%7C"+r_lat+","+r_lon
  end
  
  def add_type_marker(dpreciptype,resort)
    #eg: color:0xFFFF00%7Clabel:B%7C62.107733,-145.541936
    color = Marker.get_pcp_type_description(dpreciptype)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  def add_prob_marker(dprecipprob,resort)
    color = Marker.get_pcp_prob_description(dprecipprob)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  def add_accum_marker(dprecipaccum,resort)
    color = Marker.get_pcp_accum_description(dprecipaccum)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  def generate_map_url
    string_base = "https://maps.googleapis.com/maps/api/staticmap?"
    size_type = "size=225x150&maptype=terrain&markers="
    m_string = @marker_strings.join("&markers=")
    @url = string_base + size_type + m_string
  end
    
end