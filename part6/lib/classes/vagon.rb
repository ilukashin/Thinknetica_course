# frozen_string_literal: true

class Vagon
  include Manufacturer
  include Validation

  TYPE_FORMAT = /\w{4}\w*/.freeze

  attr_accessor :is_attached
  attr_reader :type, :capacity, :loaded_space

  validate :type, :format, TYPE_FORMAT

  def initialize(type, capacity)
    @type = type
    @is_attached = false
    @capacity = capacity
    @loaded_space = 0
    validate!
  end

  def free_space
    capacity - loaded_space
  end

  private

  attr_writer :loaded_space

  def enough_space?(value)
    free_space >= value
  end
end
