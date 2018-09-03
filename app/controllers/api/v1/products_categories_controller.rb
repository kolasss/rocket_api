# frozen_string_literal: true

module Api
  module V1
    class ProductsCategoriesController < ApplicationController
      def create
        set_shop
        @category = @shop.products_categories.new(category_params)

        if @category.save
          render(
            json: @category,
            status: :created,
            location: api_v1_shop_path(@shop)
          )
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def update
        set_category
        if @category.update(category_params)
          render json: @category
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def destroy
        set_category
        @category.destroy
      end

      private

      def set_shop
        @shop = Shops::Shop.find(params[:shop_id])
      end

      def set_category
        set_shop
        @category = @shop.products_categories.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:title)
      end
    end
  end
end
