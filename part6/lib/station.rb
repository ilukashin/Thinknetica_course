# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /\w{3}\w*/.freeze

  attr_reader :trains, :name

  validate :name, :format, NAME_FORMAT

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

  def each_train
    trains.each { |train| yield(train) }
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
end
