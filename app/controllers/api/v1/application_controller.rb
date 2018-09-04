# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      private

      def json_success(data = nil)
        Oj.dump data: data
      end

      def json_error(code: nil, message: nil, errors: nil)
        json = {}
        json[:code] = code if code.present?
        json[:message] = message if message.present?
        json[:errors] = errors if errors.present?
        Oj.dump error: json
      end
    end
  end
end
