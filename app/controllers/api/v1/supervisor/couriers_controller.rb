# frozen_string_literal: true

module Api
  module V1
    module Supervisor
      class CouriersController < ApplicationController
        def index
          operation = Operations::V1::Couriers::ListOnline.new
          result = operation.call

          if result.success?
            couriers = result.value!
            couriers_json = Api::V1::Users::Serializer.new(
              couriers
            ).build_schema
            render json: json_success(items: couriers_json)
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
