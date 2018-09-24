# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationController < ApplicationController
        skip_before_action :authenticate

        def create
          operation = Operations::V1::Users::Register.new
          result = operation.call(request.parameters)

          if result.success?
            @user = result.value!
            render(
              json: json_success(serialize_user),
              status: :created,
              location: api_v1_user_path(@user)
            )
          else
            render_error(result.failure)
          end
        end

        # def resend_code
        #   head :ok
        # end

        private

        def render_error(errors)
          json = json_error(
            code: 422,
            errors: errors
          )
          render(
            json: json,
            status: :unprocessable_entity
          )
        end

        def serialize_user
          Api::V1::Users::Serializer.new(@user).build_schema
        end
      end
    end
  end
end
