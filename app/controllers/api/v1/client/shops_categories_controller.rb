# frozen_string_literal: true

module Api
  module V1
    module Client
      class ShopsCategoriesController < ApplicationController
        skip_before_action :authenticate

        def index
          @categories = ::Shops::Category.all

          categories_json = Api::V1::ShopsCategories::CompactSerializer.new(
            @categories
          ).build_schema

          render json: json_success(items: categories_json)
        end
      end
    end
  end
end
