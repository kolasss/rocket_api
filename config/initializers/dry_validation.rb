# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

# monkey patch to convert integer keys of errors to strings
module Dry
  module Validation
    class Message
      def initialize(predicate, path, text, options)
        @predicate = predicate
        @path = format_path(path)
        @text = text
        @options = options
        @rule = options[:rule]
        @args = options[:args] || EMPTY_ARRAY

        @path << rule if predicate == :key?
      end

      private

      def format_path(path)
        path.map { |e| e.is_a?(Integer) ? e.to_s : e }
      end
    end
  end
end
