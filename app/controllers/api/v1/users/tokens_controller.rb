# frozen_string_literal: true

module Api
  module V1
    module Users
      class TokensController < ApplicationController
        def update
          operation = Operations::V1::Users::Tokens::Update.new
          result = operation.call(
            params: request.parameters,
            user: current_user
          )

          if result.success?
            head :no_content
          else
            render_error(
              status: :unprocessable_entity,
              errors: result.failure
            )
          end
        end
      end
    end
  end
end
