class Vagon
  attr_accessor :is_attached
  attr_reader :type
  
  def initialize(type)
    @type = type
    @is_attached = false
  end
end
