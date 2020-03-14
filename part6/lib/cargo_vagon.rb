# frozen_string_literal: true

class CargoVagon < Vagon
  def initialize(capacity)
    super('Cargo', capacity)
  end

  def fill(value)
    raise 'Not enough space!' unless enough_space?(value)

    self.loaded_space += value
  end
end
