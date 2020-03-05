# Класс Train (Поезд):
# Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
# Может набирать скорость
# Может возвращать текущую скорость
# Может тормозить (сбрасывать скорость до нуля)
# Может возвращать количество вагонов
# Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# Может принимать маршрут следования (объект класса Route). 
# При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

class Train
  attr_reader :speed, :vagons_count, :current_station, :type, :number

  def initialize(number, type, vagons_count)
    @number = number
    @type = type
    @vagons_count = vagons_count

    @speed = 0
  end

  public

  def increase_speed(speed = 1)
    @speed += speed
  end

  def break_speed(speed = 1)
    @speed -= speed
  end

  def attach_vagon
    is_staying ? @vagons_count += 1 : puts('Нужно остановиться!')
  end

  def detach_vagon
    is_staying ? @vagons_count -= 1 : puts('Нужно остановиться!')
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
    @route.route_points[next_station_index]
  end

  def previous_station
    @route.route_points[previous_station_index]
  end

  def to_s
    "Поезд  №#{@number},#{type}\nОстановка: #{current_station}\n#{@route}"
  end

  private

  def is_staying
    speed == 0
  end

  def change_current_station(index)
    @current_station.depart_train(self) if defined?(@current_station)
    @current_station = @route.route_points[index]
    @current_station.arrive_train(self)
    @current_station_index = index
  end

  def next_station_index
    @current_station_index + 1
  end

  def previous_station_index
    @current_station_index - 1
  end

end
