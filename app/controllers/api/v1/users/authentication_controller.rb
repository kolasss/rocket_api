# frozen_string_literal: true

module Api
  module V1
    module Users
      class AuthenticationController < ApplicationController
        skip_before_action :authenticate

        def create
          operation = Operations::V1::Users::Authenticate.new
          result = operation.call(request.parameters)

          if result.success?
            token = result.value!
            render(
              json: json_success(token: token),
              status: :created
            )
          else
            render_not_authorized
          end
        end

        # def destroy
        #   head :no_content
        # end
      end
    end
  end
end
