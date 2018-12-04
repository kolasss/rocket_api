# frozen_string_literal: true

module Api
  module V1
    module Courier
      class OrdersController < ApplicationController
        def index
          @orders = current_user.orders.order_by(created_at: :desc)

          orders_json = Api::V1::Orders::Serializer.new(
            @orders
          ).build_schema

          render json: json_success(items: orders_json)
        end

        def show
          @order = current_user.orders.find(params[:id])
          render json: json_success(serialize_order)
        end

        private

        def serialize_order
          Api::V1::Orders::DetailedSerializer.new(@order).build_schema
        end
      end
    end
  end
end
