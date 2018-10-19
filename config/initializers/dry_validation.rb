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

    module MyPredicates
      include Dry::Logic::Predicates

      predicate(:file?) do |value|
        value.is_a? ActionDispatch::Http::UploadedFile
      end

      predicate(:numeric?) do |value|
        value.is_a? Numeric
      end
    end
  end
end

Dry::Validation::Schema.configure do |config|
  config.messages = :i18n
  config.predicates = Dry::Validation::MyPredicates
  config.input_processor = :json
  config.hash_type = :symbolized
end
