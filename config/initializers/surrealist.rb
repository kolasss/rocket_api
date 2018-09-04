# frozen_string_literal: true

module Surrealist
  # A class that determines the correct value to return for serialization.
  module ValueAssigner
    class << self
      private

      # redefine to enable invoke of inherited methods for serializer
      def invoke_method(instance, method)
        instance.send(method)
      end
    end
  end
end

Surrealist.configure do |config|
  config.camelize = true
end
