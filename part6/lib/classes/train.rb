# frozen_string_literal: true

class Train
  include InstanceCounter
  include Manufacturer
  include Validation

  TYPE_FORMAT = /\w+/.freeze
  NUMBER_FORMAT = /^\w{3}-?\w{2}$/.freeze
  
  attr_reader :speed, :vagons, :current_station, :type, :number

  validate :number, :format, NUMBER_FORMAT
  validate :type, :presence
  validate :type, :format, TYPE_FORMAT

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @vagons = []
    @speed = 0
    @@trains[number] = self
    validate!
    register_instance
  end

  def each_vagon
    vagons.each { |vagon| yield(vagon) }
  end

  def increase_speed(speed = 1)
    self.speed += speed
  end

  def break_speed(speed = 1)
    self.speed -= speed
  end

  def attach_vagon(vagon)
    return puts 'Нужно остановиться!' unless staying?

    raise 'Не подходящий вагон!' unless vagon_available?(vagon)

    vagons << vagon
    vagon.is_attached = true
  end

  def detach_vagon
    raise 'Нужно остановиться!' unless staying?

    vagon = vagons.last
    vagons.delete(vagon)
    vagon.is_attached = false
  end

  def route=(route)
    @route = route
    change_current_station(0)
  end

  def move_forward
    change_current_station(next_station_index)
  end

  def move_backward
    change_current_station(previous_station_index)
  end

  def next_station
    stations[next_station_index]
  end

  def previous_station
    stations[previous_station_index]
  end

  def to_s
    "Поезд №#{number}, тип - #{type}"
  end

  private

  attr_accessor :current_station_index
  attr_writer :speed, :vagons, :current_station
  attr_reader :route

  def staying?
    speed.zero?
  end

  def vagon_available?(vagon)
    vagon.type.eql?(type) && !vagon.is_attached
  end

  def stations
    route.route_points
  end

  def change_current_station(index)
    current_station&.depart_train(self)
    self.current_station = stations[index]
    current_station.arrive_train(self)
    self.current_station_index = index
  end

  def next_station_index
    current_station_index + 1
  end

  def previous_station_index
    current_station_index - 1
  end
end
