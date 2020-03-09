class Train
  include Manufacturer, InstanceCounter
  attr_reader :speed, :vagons, :current_station, :type, :number

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
    register_instance
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
       puts 'Не подходящий вагон!'
    end
  end

  def detach_vagon
    if is_staying?
      vagon = vagons.last
      vagons.delete(vagon)
      vagon.is_attached = false
    else 
      puts 'Нужно остановиться!'
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
    "Поезд  №#{number},#{type}\nОстановка: #{current_station}\n#{route}"
  end

  # ниже все методы приватные, потому что они используются только внутри класса train
  # это его внутренняя реализация, которую мы инкапсулируем
  private

  attr_accessor :current_station_index
  attr_writer :speed, :vagons, :current_station
  attr_reader :route

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
