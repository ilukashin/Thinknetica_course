class CargoVagon < Vagon

  def initialize(capacity)
    super('Cargo', capacity)    
  end

  def fill(value)
    have_enough_space?(value) ? self.loaded_space += value : raise('Not enough space!')
  end
end
