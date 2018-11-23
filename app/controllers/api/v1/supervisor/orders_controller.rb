# frozen_string_literal: true

module Api
  module V1
    module Supervisor
      class OrdersController < ApplicationController
        def index
          @orders = ::Orders::Order.all

          orders_json = Api::V1::Orders::Serializer.new(
            @orders
          ).build_schema

          render json: json_success(items: orders_json)
        end

        def show
          set_order
          render json: json_success(serialize_order)
        end

        def assign_courier
          operation = Operations::V1::Orders::AssignCourier.new
          result = operation.call(
            id: params[:order_id],
            courier_id: params[:courier_id]
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

        def cancel
          operation = Operations::V1::Orders::Supervisor::Cancel.new
          result = operation.call(params[:order_id])

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

        private

        def set_order
          @order = ::Orders::Order.find(params[:id])
        end

        def serialize_order
          Api::V1::Orders::Serializer.new(@order).build_schema
        end
      end
    end
  end
end
