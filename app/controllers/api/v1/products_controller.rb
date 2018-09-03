# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      def create
        set_category
        @product = @category.products.new(product_params)

        if @product.save
          render(
            json: @product,
            status: :created,
            location: api_v1_shop_path(@shop)
          )
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def update
        set_product
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def destroy
        set_product
        @product.destroy
      end

      private

      def set_category
        @shop = Shops::Shop.find(params[:shop_id])
        @category = @shop.products_categories.find(
          params[:products_category_id]
        )
      end

      def set_product
        set_category
        @product = @category.products.find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          :title,
          :description,
          :price,
          :weight
        )
      end
    end
  end
end
