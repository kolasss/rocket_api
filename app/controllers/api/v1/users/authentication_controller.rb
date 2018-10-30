# frozen_string_literal: true

module Api
  module V1
    module Users
      class AuthenticationController < ApplicationController
        skip_before_action :authenticate

        def create
          operation = Operations::V1::Users::Common::Authenticate.new
          result = operation.call(request.parameters)

          if result.success?
            token = result.value![:token]
            @user = result.value![:user]
            render(
              json: json_success(
                token: token,
                user: serialize_user
              ),
              status: :created
            )
          else
            render_not_authorized
          end
        end

        # def destroy
        #   head :no_content
        # end

        private

        def serialize_user
          Api::V1::Users::Serializer.new(@user).build_schema
        end
      end
    end
  end
end
