class Route
  include InstanceCounter
  attr_reader :departure, :destination

  def initialize(departure, destination)
    @departure = departure
    @destination = destination
    @intermediate_points = []
    validate!
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  def validate!
    raise 'Wrong route parameters!' unless route_points.each { |el| el.is_a?(Station) }
  end

end
