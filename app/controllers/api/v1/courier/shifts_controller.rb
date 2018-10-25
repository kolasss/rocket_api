# frozen_string_literal: true

module Api
  module V1
    module Courier
      class ShiftsController < ApplicationController
        def create
          operation = Operations::V1::Couriers::Shifts::Start.new
          result = operation.call(current_user)

          if result.success?
            head :created
          else
            render_error(
              status: :bad_request,
              errors: result.failure
            )
          end
        end

        def destroy
          operation = Operations::V1::Couriers::Shifts::Stop.new
          result = operation.call(current_user)

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
