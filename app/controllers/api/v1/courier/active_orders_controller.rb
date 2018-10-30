# frozen_string_literal: true

module Api
  module V1
    module Courier
      class ActiveOrdersController < ApplicationController
        def show
          @order = current_user.active_order
          if @order.present?
            render json: json_success(serialize_order_detailed)
          else
            head :no_content
          end
        end

        def accept
          operation = Operations::V1::Orders::Courier::Accept.new
          result = operation.call(current_user)

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

        def decline
          operation = Operations::V1::Orders::Courier::Decline.new
          result = operation.call(
            params: request.parameters,
            courier: current_user
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

        def arrive
          operation = Operations::V1::Orders::Courier::Arrive.new
          result = operation.call(current_user)

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

        def pick_up
          operation = Operations::V1::Orders::Courier::PickUp.new
          result = operation.call(current_user)

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

        def deliver
          operation = Operations::V1::Orders::Courier::Deliver.new
          result = operation.call(current_user)

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

        def serialize_order
          Api::V1::Orders::Serializer.new(@order).build_schema
        end

        def serialize_order_detailed
          Api::V1::Orders::DetailedSerializer.new(@order).build_schema
        end
      end
    end
  end
end
