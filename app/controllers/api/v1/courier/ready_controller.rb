# frozen_string_literal: true

module Api
  module V1
    module Courier
      class ReadyController < ApplicationController
        def create
          operation = Operations::V1::Couriers::Ready.new
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
          operation = Operations::V1::Couriers::Unready.new
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
