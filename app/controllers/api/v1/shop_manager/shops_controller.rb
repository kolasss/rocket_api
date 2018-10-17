# frozen_string_literal: true

module Api
  module V1
    module ShopManager
      class ShopsController < ApplicationController
        def show
          @shop = current_user.shop
          render json: json_success(serialize_shop)
        end

        def update
          operation = Operations::V1::Shops::Update.new
          result = operation.call(
            params: request.parameters,
            shop: current_user.shop
          )

          if result.success?
            @shop = result.value!
            render json: json_success(serialize_shop)
          else
            render_error(
              status: :unprocessable_entity,
              errors: result.failure
            )
          end
        end

        private

        def serialize_shop
          Api::V1::Shops::Serializer.new(@shop).build_schema
        end
      end
    end
  end
end
