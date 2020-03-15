# frozen_string_literal: true

module Accessors
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Layout/LineLength
  def attr_accessor_with_history(*names)
    names.each do |name|
      name_variable = "@#{name}".to_sym
      name_history_variable = "@#{name}_history".to_sym

      define_method(name) { instance_variable_get(name_variable) }
      define_method("#{name}_history".to_sym) { instance_variable_get(name_history_variable) }

      define_method("#{name}=".to_sym) do |value|
        history_value = instance_variable_get(name_history_variable) || [instance_variable_get(name_variable)]
        instance_variable_set(name_history_variable, history_value << value)

        instance_variable_set(name_variable, value)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Layout/LineLength

  def strong_attr_accessor(name, type)
    name_variable = "@#{name}".to_sym
    define_method(name) { instance_variable_get(name_variable) }

    define_method("#{name}=".to_sym) do |value|
      unless value.is_a?(type)
        raise TypeError, "Wrong argument: '#{value}' for variable: #{name}"
      end

      instance_variable_set(name_variable, value)
    end
  end
end
