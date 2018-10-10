# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DistrictsController < ApplicationController
        def index
          @districts = ::Locations::District.all

          districts_json = Api::V1::Districts::Serializer.new(
            @districts
          ).build_schema

          render json: json_success(items: districts_json)
        end

        def create
          @district = ::Locations::District.new(district_params)

          if @district.save
            render(
              json: json_success(serialize_district),
              status: :created,
              location: api_v1_admin_districts_path
            )
          else
            render_district_error
          end
        end

        def update
          set_district
          if @district.update(district_params)
            render json: json_success(serialize_district)
          else
            render_district_error
          end
        end

        def destroy
          set_district
          if @district.destroy
            head :no_content
          else
            render_district_error
          end
        end

        private

        def set_district
          @district = ::Locations::District.find(params[:id])
        end

        def district_params
          params.require(:district).permit(:title)
        end

        def render_district_error
          render_error(
            status: :unprocessable_entity,
            errors: @district.errors.as_json
          )
        end

        def serialize_district
          Api::V1::Districts::Serializer.new(
            @district
          ).build_schema
        end
      end
    end
  end
end
