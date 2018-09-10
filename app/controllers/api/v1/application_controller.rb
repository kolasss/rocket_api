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

      rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found

      def not_found
        json = json_error(
          code: 404,
          message: 'Not Found'
        )
        render(
          json: json,
          status: :not_found
        )
      end
    end
  end
end
