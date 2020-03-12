class PassengerVagon < Vagon
  
  def initialize(capacity)
    super('Passenger', capacity)
  end

  def fill
    have_enough_space?(1) ? self.loaded_space += 1 : raise('No more free seats!')
  end
end
