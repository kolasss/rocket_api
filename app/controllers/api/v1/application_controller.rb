# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      include UserAuthentication::Controller

      before_action :authenticate

      private

      def json_success(data)
        Oj.dump(data: data)
      end

      def json_error(code: nil, message: nil, errors: nil)
        json = {}
        json[:code] = code if code.present?
        json[:message] = message if message.present?
        json[:errors] = errors if errors.present?
        Oj.dump(error: json)
      end

      def render_error(status:, message: nil, errors: nil)
        code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
        json = json_error(
          code: code,
          message: message,
          errors: errors
        )
        render(
          json: json,
          status: status
        )
      end

      rescue_from Mongoid::Errors::DocumentNotFound, with: :render_not_found

      def render_not_found
        render_error(
          status: :not_found,
          message: 'Not Found'
        )
      end

      def authenticate
        render_not_authorized unless logged_in?
      end

      def render_not_authorized
        render_error(
          status: :unauthorized,
          message: 'Unauthorized'
        )
      end
    end
  end
end
