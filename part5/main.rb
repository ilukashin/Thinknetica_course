require_relative 'station'
require_relative 'route'
# сначала загружаем абстрактные классы
require_relative 'train'
require_relative 'vagon'
# потом конкретные реализации
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_vagon'
require_relative 'cargo_vagon'

class Main
  attr_accessor :stations, :trains, :vagons, :routes

  ACTIONS_DISCRIPTION = <<-EOS
    1 - Создать станцию
    2 - Создать поезд
    3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
    4 - Назначить маршрут поезду
    5 - Добавить вагоны к поезду
    6 - Отцепить вагоны от поезда
    7 - Перемещение поездов
    8 - Список станций и список поездов на станциях
    9 - Выход
  EOS

  TYPES = <<-EOS
    1 - пассажирский
    2 - грузовой
  EOS

  ROUTE_OPTIONS = <<-EOS
    1 - Создать маршрут
    2 - Добавить точку
    3 - Удалить точку
  EOS

  MOVE_OPTIONS = <<-EOS
    1 - Ехать вперед
    2 - Ехать назад
  EOS

  WELCOME_MESSAGE = 'Добро пожаловать в панель управления ТрансМяс!'

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @vagons = []
    puts WELCOME_MESSAGE
  end

  def run
    loop do
      puts 'Выберите действие:', ACTIONS_DISCRIPTION
      case selected_option
      when 1 then create_station
      when 2 then create_train
      when 3 then create_and_manage_route
      when 4 then assign_route_to_train
      when 5 then add_vagons_to_train
      when 6 then delete_vagons_from_train
      when 7 then move_train
      when 8 then stations_info
      when 9 then exit
        break
      else wrong_input
      end
    end
  end

  private 

  def create_station
    puts 'Создание станции.', 'Введите название:'
    station = Station.new(input_string)
    stations << station
    puts "Успешно создана станция #{station}!"
  end

  def input_string
    gets.chomp
  end

  def create_train
    puts 'Создание поезда.', 'Выберите тип поезда:', TYPES
    case selected_option
    when 1 
      puts 'Введите номер:'
      trains << PassengerTrain.new(input_string)
      puts 'Успешно создан пассажирский поезд!'
    when 2
      puts 'Введите номер:'
      trains << CargoTrain.new(input_string)
      puts 'Успешно создан грузовой поезд!'
    else
      wrong_input
    end
  end

  def selected_option
    gets.chomp.to_i
  end

  def wrong_input
    puts 'Неправильный ввод!'
  end

  def create_and_manage_route
    puts 'Выберите действие:', ROUTE_OPTIONS
    case selected_option
    when 1 then create_route
    when 2 then add_point
    when 3 then delete_point
    else wrong_input
    end
  end

  def create_route
    if stations.size < 2
      puts 'Не хватает точек маршрута. Создать? [y/n]'
      create_station if input_string == 'y'
    else
      puts 'Создание маршрута.', 'Выберите точку отправления:'
      show_stations
      from = selected_option

      puts 'Выберите точку назначения:'
      show_stations
      to = selected_option

      routes << Route.new(stations[from], stations[to])
      puts 'Маршрут создан. Хотите добавить промежуточные точки? [y/n]'
      add_point if input_string == 'y'
    end
  end

  def show_stations
    stations.each_with_index { |station, i| puts "#{i} - #{station.name}" }
  end

  def add_point
    puts 'Выберите маршрут:'
    show_routes
    route = routes[selected_option]
    if route
      puts 'Выберите станцию:'
      show_stations
      station = stations[selected_option]
      route.add_intermediate_point(station)
      puts 'Успешно добавлена точка маршрута.'
    else
      wrong_input
    end
  end

  def show_routes
    routes.each_with_index { |route, i| puts "#{i} - #{route.departure} - #{route.destination}" }
  end

  def delete_point
    puts 'Выберите маршрут'
    show_routes
    route = routes[selected_option]
    
    puts 'Какую точку удалить?'
    points = route.route_points
    points.each_with_index { |point, i| puts "#{i} - #{point}" }
    point_to_delete = points[selected_option]

    route.delete_intermediate_point(point_to_delete)
  end

  def assign_route_to_train
    puts 'Назначение маршрута', 'Выберите поезд:'
    show_trains
    train = trains[selected_option]

    puts 'Выберите маршрут:'
    show_routes
    route = routes[selected_option]

    train.route = route
  end

  def show_trains
    trains.each_with_index { |train, i| puts "#{i} - #{train.number}, #{train.type}" }
  end
  
  def add_vagons_to_train
    puts 'Добавление вагонов к поезду.'
    loop do
      if available_vagons.empty?
        puts 'Нет свободных вагонов, хотите создать? [y/n]'
        case input_string 
        when 'y' then create_vagon
        when 'n' then break
        else wrong_input
        end
      else
        if trains.empty?
          puts 'Нет поездов, хотите создать? [y/n]'
          case input_string 
          when 'y' then create_train
          when 'n' then break
          else wrong_input
          end
        else
          puts 'Выберите поезд:'
          show_trains
          train = trains[selected_option]

          puts 'Выберите вагон:'
          show_available_vagons
          vagon = vagons[selected_option]

          train.attach_vagon(vagon)
          puts 'Успешно прицеплен вагон!'
          break
        end
      end
    end
  end

  def available_vagons
    vagons.select { |vagon| vagon unless vagon.is_attached }
  end
  
  def show_available_vagons
    vagons.each_with_index { |vagon, i| puts "#{i} - #{vagon.type}" unless vagon.is_attached }
  end
  
  def create_vagon
    puts 'Выберите тип вагона:', TYPES
    case selected_option
    when 1
      vagons << PassengerVagon.new
      puts 'Успешно создан пассажирский вагон!'
    when 2
      vagons << CargoVagon.new
      puts 'Успешно создан грузовой вагон!'
    else
      wrong_input
    end
  end

  def delete_vagons_from_train
    puts 'От какого поезда хотите отцепить вагон?'
    show_not_empty_trains
    train = trains[selected_option]
    if train
      train.detach_vagon
      puts 'Успешно отцеплен вагон!'
    else
      wrong_input
    end
  end

  def show_not_empty_trains
    trains.each_with_index { |train, i| puts "#{i} - #{train.number}, #{train.type}" if train.vagons.count > 0 }
  end

  def move_train
    puts 'Выберите поезд:'
    show_trains
    train = trains[selected_option]

    puts 'Выберите действие:', MOVE_OPTIONS
    case selected_option
    when 1 then train.move_forward
    when 2 then train.move_backward
    else wrong_input
    end
  end

  def stations_info
    puts 'Список станций:'
    show_stations
    station = stations[selected_option]

    puts "Список поездов на станции #{station}:"
    puts station.trains
  end

  def exit
    puts 'До свидания!'
  end
end

Main.new.run
