class Train
  include Manufacturer, InstanceCounter
  attr_reader :speed, :vagons, :current_station, :type, :number

  TYPE_FORMAT = /\w+/
  NUMBER_FORMAT = /^\w{3}-?\w{2}$/
  NUMBER_LENGTH = 5

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

  def each_vagon(&block)
    vagons.each { |vagon| yield(vagon) }
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def increase_speed(speed = 1)
    self.speed += speed
  end

  def break_speed(speed = 1)
    self.speed -= speed
  end

  def attach_vagon(vagon)
    return puts 'Нужно остановиться!' unless is_staying?
    if vagon_available?(vagon)
      vagons << vagon
      vagon.is_attached = true
    else
      raise 'Не подходящий вагон!'
    end
  end

  def detach_vagon
    if is_staying?
      vagon = vagons.last
      vagons.delete(vagon)
      vagon.is_attached = false
    else 
      raise 'Нужно остановиться!'
    end
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

  # ниже все методы приватные, потому что они используются только внутри класса train
  # это его внутренняя реализация, которую мы инкапсулируем
  private

  attr_accessor :current_station_index
  attr_writer :speed, :vagons, :current_station
  attr_reader :route

  def validate!
a    raise "Invalid number '#{number}'" if number !~ NUMBER_FORMAT
    raise 'Invalid number length' unless number.sub('-','').length.eql?(NUMBER_LENGTH)
    raise "Invalid type '#{type}'" if type !~ TYPE_FORMAT 
  end

  def is_staying?
    speed.zero?
  end

  def vagon_available?(vagon)
    vagon.type.eql?(type) && !vagon.is_attached
  end

  def stations
    route.route_points
  end

  def change_current_station(index)
    current_station.depart_train(self) if current_station
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
