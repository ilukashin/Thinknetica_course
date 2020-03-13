Dir["./lib/modules/*.rb"].each { |file| require file }
Dir["./lib/classes/*.rb"].each { |file| require file }
Dir["./lib/*.rb"].each { |file| require file }

class Main
  attr_accessor :stations, :trains, :vagons, :routes

  ACTIONS_DISCRIPTION = <<-EOS
    1 - Создать станцию
    2 - Создать поезд
    3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
    4 - Назначить маршрут поезду
    5 - Добавить вагоны к поезду
    55 - Посмотреть вагоны поезда
    56 - Заполнить вагон
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
      invitation_to_make_choice(ACTIONS_DISCRIPTION)
      case selected_option
      when 1 then create_station
      when 2 then create_train
      when 3 then create_and_manage_route
      when 4 then assign_route_to_train
      when 5 then add_vagons_to_train
      when 55 then list_train_vagons
      when 56 then fill_vagon
      when 6 then delete_vagons_from_train
      when 7 then move_train
      when 8 then stations_info
      when 9 then exit
        break
      else info_wrong_input
      end
    end
  end

  private 

  def invitation_to_make_choice(options_list = nil)
    puts 'Выберите нужный вариант:'
    puts options_list if options_list
  end

  def create_station
    puts 'Создание станции.', 'Введите название:'
    stations << Station.new(input_string)
    info_success
  end

  def input_string
    gets.chomp
  end

  def create_train
    puts 'Создание поезда.'
    invitation_to_make_choice(TYPES)
    case selected_option
    when 1 
      puts 'Введите номер:'
      train = PassengerTrain.new(input_string)
      trains << train
      info_success(train)
    when 2
      puts 'Введите номер:'
      train = CargoTrain.new(input_string)
      trains << train
      info_success(train)
    else
      info_wrong_input
    end
  rescue StandardError => e
    puts '!!! Error: ' + e.message
    retry
  end

  def selected_option
    gets.chomp.to_i
  end

  def info_wrong_input
    puts 'Неправильный ввод!'
  end

  def info_success(info = nil)
    puts 'Успешно!'
    puts info if info
  end

  def create_and_manage_route
    invitation_to_make_choice(ROUTE_OPTIONS)
    case selected_option
    when 1 then create_route
    when 2 then add_point
    when 3 then delete_point
    else info_wrong_input
    end
  end

  def create_route
    if stations.size < 2
      puts 'Не хватает точек маршрута. Создать? [y/n]'
      create_station if input_string.eql?('y')
    else
      puts 'Создание маршрута. <Откуда> - <Куда>'
      invitation_to_make_choice(get_all_stations)
      from = selected_option

      invitation_to_make_choice(get_all_stations)
      to = selected_option

      routes << Route.new(stations[from], stations[to])
      puts 'Маршрут создан. Хотите добавить промежуточные точки? [y/n]'
      add_point if input_string.eql?('y')
    end
  end

  def get_all_stations
    stations.each_with_index { |station, i| "#{i} - #{station.name}" }
  end

  def add_point
    invitation_to_make_choice(get_all_routes)    
    route = routes[selected_option]
    if route
      invitation_to_make_choice(get_all_stations)
      station = stations[selected_option]
      route.add_intermediate_point(station)
      info_success
    else
      info_wrong_input
    end
  end

  def get_all_routes
    routes.collect.with_index { |route, i| "#{i} - #{route.departure} - #{route.destination}" }
  end

  def delete_point
    invitation_to_make_choice(get_all_routes)
    route = routes[selected_option]
    
    puts 'Какую точку удалить?'
    points = route.route_points
    invitation_to_make_choice(get_all_route_points(points))
    point_to_delete = points[selected_option]

    route.delete_intermediate_point(point_to_delete)
  end

  def get_all_route_points(points)
    points.collect.with_index { |point, i| "#{i} - #{point}" }
  end

  def assign_route_to_train
    puts 'Назначение маршрута'
    invitation_to_make_choice(get_all_trains)
    train = trains[selected_option]

    invitation_to_make_choice(get_all_routes)
    route = routes[selected_option]

    train.route = route
  end

  def get_all_trains
    trains.collect.with_index { |train, i| "#{i} - #{train.number}, #{train.type}" }
  end
  
  def add_vagons_to_train
    puts 'Добавление вагонов к поезду.'
    loop do
      if available_vagons.empty?
        puts 'Нет свободных вагонов, хотите создать? [y/n]'
        case input_string 
        when 'y' then create_vagon
        when 'n' then break
        else info_wrong_input
        end
      else
        if trains.empty?
          puts 'Нет поездов, хотите создать? [y/n]'
          case input_string 
          when 'y' then create_train
          when 'n' then break
          else info_wrong_input
          end
        else
          invitation_to_make_choice(get_all_trains)
          train = trains[selected_option]

          invitation_to_make_choice(get_all_available_vagons)
          vagon = vagons[selected_option]

          train.attach_vagon(vagon)
          info_success
          break
        end
      end
    end
  end

  def available_vagons
    vagons.select { |vagon| vagon unless vagon.is_attached }
  end
  
  def get_all_available_vagons
    vagons.collect.with_index { |vagon, i| "#{i} - #{vagon.type}" unless vagon.is_attached }
  end
  
  def create_vagon
    invitation_to_make_choice(TYPES)
    case selected_option
    when 1
      vagons << init_vagon(PassengerVagon, 'Введите кол-во мест:')
      info_success
    when 2
      vagons << init_vagon(CargoVagon, 'Введите объем вагона:')
      info_success
    else
      info_wrong_input
    end
  end

  def init_vagon(vagon, message)
    puts message
    vagon.new(input_string.to_i)
  end

  def list_train_vagons
    if get_all_trains.empty?
      puts 'Нет поездов!'
    else
      invitation_to_make_choice(get_all_trains)
      train = trains[selected_option]
      train.each_vagon { |vagon| puts vagon }
    end
  end

  def fill_vagon
    invitation_to_make_choice(get_all_trains)
    train = trains[selected_option]

    puts 'Выберите вагон:'
    get_all_train_vagons(train)
    
    vagon = train.vagons[selected_option]

    # не смог придумать более язящную конструкцию
    # по условию пассажирский может заполняться за раз на +1
    # и можно былобы сделать сигнатуру def fill(value = 1)
    # но тогда бы мы могли вызвать заполнение пассажирского с любым количеством
    if vagon.type.eql?('Passenger')
      vagon.fill
    else
      vagon.fill(input_string.to_i)
    end

    info_success
  end

  def get_all_train_vagons(train)
    train.vagons.each.with_index { |vagon, i| puts i }
  end


  def delete_vagons_from_train
    invitation_to_make_choice(get_all_not_empty_trains)
    train = trains[selected_option]
    if train
      train.detach_vagon
      info_success
    else
      info_wrong_input
    end
  end

  def get_all_not_empty_trains
    trains.collect.with_index { |train, i| "#{i} - #{train.number}, #{train.type}" if train.vagons.count > 0 }
  end

  def move_train
    invitation_to_make_choice(get_all_trains)
    train = trains[selected_option]

    invitation_to_make_choice(MOVE_OPTIONS)
    case selected_option
    when 1 then train.move_forward
    when 2 then train.move_backward
    else info_wrong_input
    end
  end

  def stations_info
    invitation_to_make_choice(get_all_stations)
    station = stations[selected_option]

    puts "Список поездов на станции #{station}:"
    station.each_train { |train| puts train }
  end

  def exit
    puts 'До свидания!'
  end
end

Main.new.run
