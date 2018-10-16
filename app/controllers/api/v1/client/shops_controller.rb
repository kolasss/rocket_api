# frozen_string_literal: true

module Api
  module V1
    module Client
      class ShopsController < ApplicationController
        skip_before_action :authenticate

        def index
          district = ::Locations::District.find(params[:district_id])
          @shops = district.shops.without(:products_categories)

          shops_json = Api::V1::Shops::CompactSerializer.new(
            @shops
          ).build_schema

          render json: json_success(items: shops_json)
        end

        def show
          @shop = ::Shops::Shop.find(params[:id])
          render json: json_success(serialize_shop)
        end

        private

        def serialize_shop
          Api::V1::Shops::Serializer.new(@shop).build_schema
        end
      end
    end
  end
end
