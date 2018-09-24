# frozen_string_literal: true

module Api
  module V1
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

      def create
        @order = ::Orders::Order.new(order_params)

        if @order.save
          render(
            json: json_success(serialize_order),
            status: :created,
            location: api_v1_order_path(@order)
          )
        else
          # render json: @order.errors, status: :unprocessable_entity
          render_error
        end
      end

      def update
        set_order
        if @order.update(order_params)
          render json: json_success(serialize_order)
        else
          # render json: @order.errors, status: :unprocessable_entity
          render_error
        end
      end

      def destroy
        set_order
        if @order.destroy
          head :no_content
        else
          render_error
        end
      end

      private

      def set_order
        @order = ::Orders::Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(
          :client_id,
          :courier_id,
          :shop_id,
          :status
          # products_ids: []
        )
      end

      def render_error
        json = json_error(
          code: 422,
          errors: @order.errors.as_json
        )
        render(
          json: json,
          status: :unprocessable_entity
        )
      end

      def serialize_order
        Api::V1::Orders::Serializer.new(@order).build_schema
      end
    end
  end
end
