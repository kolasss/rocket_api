# frozen_string_literal: true

module Api
  module V1
    module ShopManager
      class ShopsController < ApplicationController
        def show
          set_shop
          render json: json_success(serialize_shop)
        end

        def update
          set_shop
          if @shop.update(shop_params)
            render json: json_success(serialize_shop)
          else
            render_error(
              status: :unprocessable_entity,
              errors: @shop.errors.as_json
            )
          end
        end

        private

        def set_shop
          @shop = current_user.shop
        end

        def shop_params
          params.require(:shop).permit(
            :title,
            :description,
            { category_ids: [] },
            :minimum_order_price
          )
        end

        def serialize_shop
          Api::V1::Shops::Serializer.new(@shop).build_schema
        end
      end
    end
  end
end
