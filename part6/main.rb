# frozen_string_literal: true

Dir['./lib/modules/*.rb'].sort.each { |file| require file }
Dir['./lib/classes/*.rb'].sort.each { |file| require file }
Dir['./lib/*.rb'].sort.each { |file| require file }

class Main
  attr_accessor :stations, :trains, :vagons, :routes

  ACTIONS_DISCRIPTION = <<-LIST
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
  LIST

  TYPES = <<-LIST
    1 - пассажирский
    2 - грузовой
  LIST

  ROUTE_OPTIONS = <<-LIST
    1 - Создать маршрут
    2 - Добавить точку
    3 - Удалить точку
  LIST

  MOVE_OPTIONS = <<-LIST
    1 - Ехать вперед
    2 - Ехать назад
  LIST

  WELCOME_MESSAGE = 'Добро пожаловать в панель управления ТрансМяс!'

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @vagons = []
    puts WELCOME_MESSAGE
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
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
      when 9 then break exit
      else info_wrong_input
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

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
    when 1 then trains << init_train(PassengerTrain)
    when 2 then trains << init_train(CargoTrain)
    else info_wrong_input
    end
  rescue StandardError => e
    puts '!!! Error: ' + e.message
    retry
  end

  def init_train(type, message = 'Введите номер:')
    puts message
    train = type.new(input_string)
    info_success(train)
    train
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
      init_route
    end
  end

  def init_route
    puts 'Создание маршрута. <Откуда> - <Куда>'
    routes << Route.new(select_station, select_station)

    puts 'Маршрут создан. Хотите добавить промежуточные точки? [y/n]'
    add_point if input_string.eql?('y')
  end

  def select_station
    invitation_to_make_choice(show_stations)
    stations[selected_option]
  end

  def show_stations
    stations.each_with_index { |station, i| "#{i} - #{station.name}" }
  end

  def add_point
    invitation_to_make_choice(show_routes)
    route = routes[selected_option]
    if route
      station = select_station
      route.add_intermediate_point(station)
      info_success
    else
      info_wrong_input
    end
  end

  def show_routes
    routes.collect
          .with_index { |route, i| "#{i}: #{route}" }
  end

  def delete_point
    invitation_to_make_choice(show_routes)
    route = routes[selected_option]

    puts 'Какую точку удалить?'
    points = route.route_points
    invitation_to_make_choice(show_route_points(points))
    point_to_delete = points[selected_option]

    route.delete_intermediate_point(point_to_delete)
  end

  def show_route_points(points)
    points.collect.with_index { |point, i| "#{i} - #{point}" }
  end

  def assign_route_to_train
    puts 'Назначение маршрута'
    train = select_train

    invitation_to_make_choice(show_routes)
    route = routes[selected_option]

    train.route = route
  end

  def select_train
    invitation_to_make_choice(show_trains)
    trains[selected_option]
  end

  def show_trains
    trains.collect
          .with_index { |train, i| "#{i} - #{train.number}, #{train.type}" }
  end

  def add_vagons_to_train
    puts 'Добавление вагонов к поезду.'
    if available_vagons.empty?
      invitation_create_vagon
    elsif trains.empty?
      invitation_create_train
    else
      select_train.attach_vagon(select_available_vagon)
      info_success
    end
  end

  def invitation_create_vagon
    puts 'Нет свободных вагонов, хотите создать? [y/n]'
    create_vagon if input_string.eql?('y')
  end

  def invitation_create_train
    puts 'Нет поездов, хотите создать? [y/n]'
    create_train if input_string.eql?('y')
  end

  def available_vagons
    vagons.select { |vagon| vagon unless vagon.is_attached }
  end

  def select_available_vagon
    invitation_to_make_choice(show_available_vagons)
    vagons[selected_option]
  end

  def show_available_vagons
    vagons.collect.with_index do |vagon, i|
      "#{i} - #{vagon.type}" unless vagon.is_attached
    end
  end

  def create_vagon
    invitation_to_make_choice(TYPES)
    case selected_option
    when 1
      vagons << init_vagon(PassengerVagon, 'Введите кол-во мест:')
    when 2
      vagons << init_vagon(CargoVagon, 'Введите объем вагона:')
    else
      info_wrong_input
    end
  end

  def init_vagon(type, message)
    puts message
    vagon = type.new(input_string.to_i)
    info_success
    vagon
  end

  def list_train_vagons
    if show_trains.empty?
      puts 'Нет поездов!'
    else
      train = select_train
      train.each_vagon { |vagon| puts vagon }
    end
  end

  def fill_vagon
    train = select_train

    puts 'Выберите вагон:'
    show_train_vagons(train)

    vagon = train.vagons[selected_option]

    if vagon.type.eql?('Passenger')
      vagon.fill
    else
      vagon.fill(input_string.to_i)
    end

    info_success
  end

  def show_train_vagons(train)
    train.vagons.each.with_index { |_vagon, i| puts i }
  end

  def delete_vagons_from_train
    invitation_to_make_choice(show_not_empty_trains)
    train = trains[selected_option]
    if train
      train.detach_vagon
      info_success
    else
      info_wrong_input
    end
  end

  def show_not_empty_trains
    trains.collect.with_index do |train, i|
      "#{i} - #{train.number}, #{train.type}" if train.vagons.count.positive?
    end
  end

  def move_train
    train = select_train

    invitation_to_make_choice(MOVE_OPTIONS)
    case selected_option
    when 1 then train.move_forward
    when 2 then train.move_backward
    else info_wrong_input
    end
  end

  def stations_info
    station = select_station

    puts "Список поездов на станции #{station}:"
    station.each_train { |train| puts train }
  end

  def exit
    puts 'До свидания!'
  end
end

Main.new.run
