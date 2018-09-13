# frozen_string_literal: true

module Surrealist
  # A class that determines the correct value to return for serialization.
  module ValueAssigner
    class << self
      private

      # redefine to enable invoke of inherited methods for serializer
      def invoke_method(instance, method)
        object = instance.instance_variable_get(:@object)
        instance_class = instance.class
        instance_method = instance_class.method_defined?(method) ||
                          instance_class.private_method_defined?(method)
        invoke_object = !instance_method && object&.respond_to?(method, true)
        invoke_object ? object.send(method) : instance.send(method)
      end
    end
  end
end

Surrealist.configure do |config|
  config.camelize = true
end
