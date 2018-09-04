# frozen_string_literal: true

module Api
  module V1
    class ShopsCategoriesController < ApplicationController
      def index
        @categories = ::Shops::Category.all

        categories_json = Api::V1::ShopsCategories::CompactSerializer.new(
          @categories
        ).build_schema

        render json: json_success(items: categories_json)
      end

      def create
        @category = ::Shops::Category.new(category_params)

        if @category.save
          render(
            json: json_success(serialize_category),
            status: :created,
            location: api_v1_shops_categories_path
          )
        else
          render_error
        end
      end

      def update
        set_category
        if @category.update(category_params)
          render json: json_success(serialize_category)
        else
          render_error
        end
      end

      def destroy
        set_category
        if @category.destroy
          render json: json_success
        else
          render_error
        end
      end

      private

      def set_category
        @category = ::Shops::Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:title)
      end

      def render_error
        json = json_error(
          code: 422,
          errors: @category.errors
        )
        render(
          json: json,
          status: :unprocessable_entity
        )
      end

      def serialize_category
        Api::V1::ShopsCategories::Serializer.new(
          @category
        ).build_schema
      end
    end
  end
end
