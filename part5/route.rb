class Route
  attr_reader :departure, :destination

  private

  attr_accessor :intermediate_points

  def initialize(departure, destination)
    @departure = departure
    @destination = destination
    @intermediate_points = []
  end

  public

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
end
