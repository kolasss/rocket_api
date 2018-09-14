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

      rescue_from Mongoid::Errors::DocumentNotFound, with: :render_not_found

      def render_not_found
        json = json_error(
          code: 404,
          message: 'Not Found'
        )
        render(
          json: json,
          status: :not_found
        )
      end

      def authenticate
        render_not_authorized unless logged_in?
      end

      def render_not_authorized
        json = json_error(
          code: 401,
          message: 'Unauthorized'
        )
        render(
          json: json,
          status: :unauthorized
        )
      end
    end
  end
end
