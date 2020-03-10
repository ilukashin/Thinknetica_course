class Station
  include InstanceCounter
  attr_reader :trains, :name

  NAME_FORMAT = /\w+/
  NAME_LENGTH = 3

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    validate!
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def arrive_train(train)
    trains << train
  end

  def depart_train(train)
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type } 
  end

  def to_s
    "Остановка: #{name}"
  end

  private

  attr_writer :trains

  def validate!
    raise "Invalid name '#{name}'" if name !~ NAME_FORMAT
    raise 'Name is too short!' if name.length < NAME_LENGTH
  end
end
