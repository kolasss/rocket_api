# frozen_string_literal: true

module Api
  module V1
    module Client
      class DistrictsController < ApplicationController
        skip_before_action :authenticate

        def index
          @districts = ::Locations::District.all

          districts_json = Api::V1::Districts::Serializer.new(
            @districts
          ).build_schema

          render json: json_success(items: districts_json)
        end
      end
    end
  end
end
