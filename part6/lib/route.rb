# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :departure, :destination

  validate :departure, :type, Station
  validate :destination, :type, Station

  def initialize(departure, destination)
    @departure = departure
    @destination = destination
    @intermediate_points = []
    validate!
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
    "Route: #{departure} - #{destination}"
  end

  private

  attr_accessor :intermediate_points
end
