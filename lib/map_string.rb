# Class: MapString
#
# Models a map string.
#
# Attributes:
# @marker_strings - Array: initially empty.
# @url            - String: url to send to Google Static Maps API.
#
# Public Methods:
# #add_type_marker
# #add_prob_marker
# #add_accum_marker
# #generate_map_url
#
# Private Methods:
# #label_and_location

class MapString
  
  include Marker
  
  attr_accessor :marker_strings
  attr_reader :url
  
  def initialize
    @marker_strings  = []
  end

  # Public: #add_type_marker
  # Generates a marker string to represent resort precipitation type.
  #
  # Parameters:
  # @dpreciptype - String: contains precipitation type.
  # @resort      - Object: Resort.
  #
  # Returns:
  # @marker_strings.
  #
  # State Changes:
  # Adds string to @marker_strings.

  def add_type_marker(dpreciptype,resort)
    #eg: color:0xFFFF00%7Clabel:B%7C62.107733,-145.541936
    color = get_pcp_type_description(dpreciptype)
    #color = Marker.get_pcp_type_description(dpreciptype)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  # Public: #add_prob_marker
  # Generates a marker string to represent resort precipitation probability.
  #
  # Parameters:
  # @dprecipprob - Number: precipitation probability.
  # @resort      - Object: Resort.
  #
  # Returns:
  # @marker_strings.
  #
  # State Changes:
  # Adds string to @marker_strings.
  
  def add_prob_marker(dprecipprob,resort)
    color = get_pcp_prob_description(dprecipprob)
    #color = Marker.get_pcp_prob_description(dprecipprob)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  # Public: #add_accum_marker
  # Generates a marker string to represent resort precipitation accumulation.
  #
  # Parameters:
  # @dprecipprob - Number: precipitation accumulation.
  # @resort      - Object: Resort.
  #
  # Returns:
  # @marker_strings.
  #
  # State Changes:
  # Adds string to @marker_strings.
  
  def add_accum_marker(dprecipaccum,resort)
    color = get_pcp_accum_description(dprecipaccum)
    #color = Marker.get_pcp_accum_description(dprecipaccum)
    @marker_strings << "color:0x" + color + label_and_location(resort)
  end
  
  # Public: #generate_map_url
  # Combines current values in @marker_strings to a url string for submission
  #  to Google Static Maps API.
  #
  # Parameters:
  # none.
  #
  # Returns:
  # @url
  #
  # State Changes:
  # none.
  
  def generate_map_url
    string_base = "https://maps.googleapis.com/maps/api/staticmap?"
    size_type = "size=225x150&maptype=terrain&markers="
    m_string = @marker_strings.join("&markers=")
    @url = string_base + size_type + m_string
  end
  
  private
    
  # Private: #label_and_location
  # Generates resort dependent portion of marker string.
  #
  # Parameters:
  # resort
  #
  # Returns:
  # string
  #
  # State Changes:
  # none.
    
  def label_and_location(resort)
    r_lat = resort.latitude.to_s
    r_lon = resort.longitude.to_s
    "%7Clabel:#{resort.name[0..0]}%7C"+r_lat+","+r_lon
  end
  
end