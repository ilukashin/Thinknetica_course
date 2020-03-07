class Station
  attr_reader :trains, :name
  
  private

  attr_writer :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  public

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
end
