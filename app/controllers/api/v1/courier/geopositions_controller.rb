# frozen_string_literal: true

module Api
  module V1
    module Courier
      class GeopositionsController < ApplicationController
        def create
          operation = Operations::V1::Couriers::Locations::Update.new
          result = operation.call(
            params: request.parameters,
            courier: current_user
          )

          if result.success?
            head :no_content
          else
            render_error(
              status: :bad_request,
              errors: result.failure
            )
          end
        end
      end
    end
  end
end
