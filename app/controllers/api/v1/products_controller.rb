# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      def create
        set_category
        @product = @category.products.new(product_params)

        if @product.save
          render(
            json: json_success(serialize_product),
            status: :created,
            location: api_v1_shop_path(@shop)
          )
        else
          render_error
        end
      end

      def update
        set_product
        if @product.update(product_params)
          render json: json_success(serialize_product)
        else
          render_error
        end
      end

      def destroy
        set_product
        if @product.destroy
          head :no_content
        else
          render_error
        end
      end

      private

      def set_category
        @shop = ::Shops::Shop.find(params[:shop_id])
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

      def render_error
        json = json_error(
          code: 422,
          errors: @product.errors
        )
        render(
          json: json,
          status: :unprocessable_entity
        )
      end

      def serialize_product
        Api::V1::Products::Serializer.new(
          @product
        ).build_schema
      end
    end
  end
end
