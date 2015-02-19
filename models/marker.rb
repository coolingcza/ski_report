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
  
  attr_reader :id, :condition
  attr_accessor :description
  
  
  
  def initialize(options)
    @id          = options["id"]
    @condition   = options["condition"]
    @description = options["description"]
    @table       = "markers"
  end
  
end