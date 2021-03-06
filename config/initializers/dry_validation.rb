# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module Dry
  module Validation
    # monkey patch to convert integer keys of errors to strings
    # to fix Oj.dump error:
    #   "In :strict and :null mode all Hash keys must be Strings or Symbols,
    #   not Integer.""
    module MessagePathConvertor
      def initialize(predicate, path, text, options)
        path = convert_path_integers(path)
        super(predicate, path, text, options)
      end

      private

      def convert_path_integers(path)
        path.map { |e| e.is_a?(Integer) ? e.to_s : e }
      end
    end

    class Message
      prepend MessagePathConvertor
    end

    # custom predicates
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
