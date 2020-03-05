# Класс Route (Маршрут):
# Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# Может добавлять промежуточную станцию в список
# Может удалять промежуточную станцию из списка
# Может выводить список всех станций по-порядку от начальной до конечной

class Route
  attr_reader :departure, :destionation

  def initialize(departure, destionation)
    @departure = departure
    @destionation = destionation
    @intermediate_points = []
  end

  public

  def add_intermediate_point(point)
    @intermediate_points << point
  end

  def delete_intermediate_point(point)
    @point.delete(point)
  end

  def route_points
    [departure] + @intermediate_points + [destionation]
  end

  def to_s
    "Маршрут: #{departure} - #{destionation}"
  end
end
