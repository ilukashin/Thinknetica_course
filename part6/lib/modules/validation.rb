# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validatons

    def validate(name, check, *args)
      @validations ||= []
      @validations << { name: name, check: check, args: args }
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@validations).each do |validation|
        name = validation[:name]
        argument = validation[:args].first
        value = instance_variable_get("@#{name}".to_sym)

        send "validate_#{validation[:check]}".to_sym, name, value, argument
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate_presence(name, value, _arg)
      raise "#{name} is not present." if value.nil? || value.eql?('')
    end

    def validate_format(name, value, pattern)
      return unless value !~ pattern

      raise "#{name}: '#{value}' is not comparable with pattern #{pattern}"
    end

    def validate_type(name, value, type)
      return if value.is_a?(type)

      raise TypeError, "#{name}: '#{value}' is not a #{type}"
    end
  end
end
