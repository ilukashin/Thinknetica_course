# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end

    def instances_enumerator
      self.instances += 1
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances_enumerator
    end
  end
end
