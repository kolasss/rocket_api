# frozen_string_literal: true

module Api
  module V1
    module Supervisor
      class CouriersController < ApplicationController
        def index
          # TODO: get couriers from redis
          @couriers = ::Users::Courier.all

          couriers_json = Api::V1::Users::Serializer.new(
            @couriers
          ).build_schema
          render json: json_success(items: couriers_json)
        end
      end
    end
  end
end
