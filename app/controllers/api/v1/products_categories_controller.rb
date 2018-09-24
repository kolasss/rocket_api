# frozen_string_literal: true

module Api
  module V1
    class ProductsCategoriesController < ApplicationController
      def create
        set_shop
        @category = @shop.products_categories.new(category_params)

        if @category.save
          render(
            json: json_success(serialize_category),
            status: :created,
            location: api_v1_shop_path(@shop)
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
          head :no_content
        else
          render_error
        end
      end

      private

      def set_shop
        @shop = ::Shops::Shop.find(params[:shop_id])
      end

      def set_category
        set_shop
        @category = @shop.products_categories.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:title)
      end

      def render_error
        json = json_error(
          code: 422,
          errors: @category.errors.as_json
        )
        render(
          json: json,
          status: :unprocessable_entity
        )
      end

      def serialize_category
        Api::V1::ProductsCategories::Serializer.new(
          @category
        ).build_schema
      end
    end
  end
end
