# frozen_string_literal: true

module Api
  module V1
    class ShopsCategoriesController < ApplicationController
      def index
        @categories = Shops::Category.all

        render json: @categories
      end

      def create
        @category = Shops::Category.new(category_params)

        if @category.save
          render(
            json: @category,
            status: :created,
            location: api_v1_shop_category_path(@category)
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

      def set_category
        @category = Shops::Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:title)
      end
    end
  end
end
