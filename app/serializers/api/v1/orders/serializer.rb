# frozen_string_literal: true

module Api
  module V1
    module Orders
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            client_id: String,
            courier_id: String,
            shop_id: String,
            status: String,
            price_total: BigDecimal,
            products: Array,
            courier_assignments: Array,
            shop_response: Hash,
            cancel_reason: String
          }
        end

        def products
          Api::V1::OrdersProducts::Serializer.new(
            object.products
          ).build_schema
        end

        def client_id
          object.client_id&.to_s
        end

        def courier_id
          object.courier_id&.to_s
        end

        def shop_id
          object.shop_id&.to_s
        end

        def courier_assignments
          AssignmentSerializer.new(
            object.courier_assignments
          ).build_schema
        end

        def shop_response
          return unless object.shop_response?

          ShopResponseSerializer.new(
            object.shop_response
          ).build_schema
        end
      end

      class AssignmentSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            status: String,
            decline_reason: String,
            courier_id: String
          }
        end

        def courier_id
          object.courier_id&.to_s
        end
      end

      class ShopResponseSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            status: String
          }
        end
      end
    end
  end
end
