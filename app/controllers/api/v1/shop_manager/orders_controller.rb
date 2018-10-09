# frozen_string_literal: true

module Api
  module V1
    module ShopManager
      class OrdersController < ApplicationController
        def index
          @shop = current_user.shop
          @orders = @shop.orders

          orders_json = Api::V1::Orders::Serializer.new(
            @orders
          ).build_schema

          render json: json_success(items: orders_json)
        end

        def accept
          operation = Operations::V1::Orders::ShopManager::Accept.new
          result = operation.call(
            id: params[:order_id],
            shop_id: current_user.shop_id
          )

          if result.success?
            @order = result.value!
            render json: json_success(serialize_order)
          else
            render_error(
              status: :bad_request,
              errors: result.failure
            )
          end
        end

        # rubocop:disable Metrics/AbcSize
        def cancel
          operation = Operations::V1::Orders::ShopManager::Cancel.new
          result = operation.call(
            id: params[:order_id],
            shop_id: current_user.shop_id,
            params: request.parameters
          )

          if result.success?
            @order = result.value!
            render json: json_success(serialize_order)
          else
            render_error(
              status: :bad_request,
              errors: result.failure
            )
          end
        end
        # rubocop:enable Metrics/AbcSize

        private

        def serialize_order
          Api::V1::Orders::Serializer.new(@order).build_schema
        end
      end
    end
  end
end
