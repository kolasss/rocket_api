# frozen_string_literal: true

module Api
  module V1
    class ShopsController < ApplicationController
      def index
        # without(:products_categories)
        @shops = Shops::Shop.all

        render json: @shops
      end

      def show
        set_shop
        render json: @shop
      end

      def create
        @shop = Shops::Shop.new(shop_params)

        if @shop.save
          render(
            json: @shop,
            status: :created,
            location: api_v1_shop_path(@shop)
          )
        else
          render json: @shop.errors, status: :unprocessable_entity
        end
      end

      def update
        set_shop
        if @shop.update(shop_params)
          render json: @shop
        else
          render json: @shop.errors, status: :unprocessable_entity
        end
      end

      def destroy
        set_shop
        @shop.destroy
      end

      private

      def set_shop
        @shop = Shops::Shop.find(params[:id])
      end

      def shop_params
        params.require(:shop).permit(
          :title,
          :description,
          category_ids: []
        )
      end
    end
  end
end
