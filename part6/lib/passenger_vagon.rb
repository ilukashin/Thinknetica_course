# frozen_string_literal: true

class PassengerVagon < Vagon
  def initialize(capacity)
    super('Passenger', capacity)
  end

  def fill
    raise 'No more free seats!' unless enough_space?(1)

    self.loaded_space += 1
  end
end
