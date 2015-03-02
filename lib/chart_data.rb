
class ChartData
  
  attr_reader :name, :data
  
  def initialize(resort_name)
    @name = resort_name
    @data = []
  end
  
  def add_data_point(pt)
    @data << pt
  end
  
end