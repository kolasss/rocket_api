# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationController < ApplicationController
        skip_before_action :authenticate

        def create
          @user = ::Users::User.new(user_params)

          if @user.save
            # generate code and send sms
            @user.update code_hash: '1234'
            render(
              json: json_success(serialize_user),
              status: :created,
              location: api_v1_user_path(@user)
            )
          else
            render_error
          end
        end

        # def resend_code
        #   head :ok
        # end

        private

        def user_params
          params.require(:user).permit(
            :name,
            :phone
          )
        end

        def render_error
          json = json_error(
            code: 422,
            errors: @user.errors
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
