class Route
  include InstanceCounter
  attr_reader :departure, :destination

  def initialize(departure, destination)
    @departure = departure
    @destination = destination
    @intermediate_points = []
    register_instance
  end

  def add_intermediate_point(point)
    intermediate_points << point
  end

  def delete_intermediate_point(point)
    intermediate_points.delete(point)
  end

  def route_points
    [departure] + intermediate_points + [destination]
  end

  def to_s
    "Маршрут: #{departure} - #{destination}"
  end

  private

  attr_accessor :intermediate_points

end
