# frozen_string_literal: true

module Api
  module V1
    module Client
      class OrdersController < ApplicationController
        def index
          @orders = current_user.orders

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
          operation = Operations::V1::Orders::Create.new
          result = operation.call(
            params: request.parameters,
            client: current_user
          )

          if result.success?
            @order = result.value!
            render(
              json: json_success(serialize_order),
              status: :created,
              location: api_v1_client_order_path(@order)
            )
          else
            render_error(result.failure)
          end
        end

        def cancel
          set_order
          # if @order.update(order_params)
          #   render json: json_success(serialize_order)
          # else
          #   # render json: @order.errors, status: :unprocessable_entity
          #   render_error
          # end
        end

        private

        def set_order
          @order = current_user.orders.find(params[:id])
        end

        def render_error(errors)
          json = json_error(
            code: 422,
            errors: errors
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
end
