# frozen_string_literal: true

class Vagon
  include Manufacturer
  attr_accessor :is_attached
  attr_reader :type, :capacity, :loaded_space

  TYPE_FORMAT = /\w+/.freeze
  TYPE_LENGTH = 4

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  attr_writer :loaded_space

  def enough_space?(value)
    free_space >= value
  end

  def validate!
    raise "Invalid name '#{type}'" if type !~ TYPE_FORMAT
    raise 'Type is too short!' if type.length < TYPE_LENGTH
  end
end
