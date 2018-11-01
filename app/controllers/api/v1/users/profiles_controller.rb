# frozen_string_literal: true

module Api
  module V1
    module Users
      class ProfilesController < ApplicationController
        def show
          @user = current_user
          render json: json_success(serialize_user)
        end

        def update
          operation = Operations::V1::Users::Common::Update.new
          result = operation.call(
            params: request.parameters,
            user: current_user
          )

          if result.success?
            @user = result.value!
            render json: json_success(serialize_user)
          else
            render_error(
              status: :unprocessable_entity,
              errors: result.failure
            )
          end
        end

        private

        def serialize_user
          Api::V1::Users::Serializer.new(@user).build_schema
        end
      end
    end
  end
end
