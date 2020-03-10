class Vagon
  include Manufacturer
  attr_accessor :is_attached
  attr_reader :type

  TYPE_FORMAT = /\w+/
  TYPE_LENGTH = 4
  
  def initialize(type)
    @type = type
    @is_attached = false
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate!
    raise "Invalid name '#{type}'" if type !~ TYPE_FORMAT
    raise 'Type is too short!' if name.length < TYPE_LENGTH
  end
end
