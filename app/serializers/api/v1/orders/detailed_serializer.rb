# frozen_string_literal: true

module Api
  module V1
    module Orders
      class DetailedSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            client: Hash,
            courier_id: String,
            shop: Hash,
            status: String,
            price_total: BigDecimal,
            products: Array,
            courier_assignments: Array,
            shop_response: Hash,
            cancel_reason: String,
            address: Hash
          }
        end

        def products
          Api::V1::OrdersProducts::Serializer.new(
            object.products
          ).build_schema
        end

        def client
          Api::V1::Users::ClientOrderSerializer.new(
            object.client
          ).build_schema
        end

        def courier_id
          object.courier_id&.to_s
        end

        def shop
          Api::V1::Shops::OrderSerializer.new(
            object.shop
          ).build_schema
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

        def address
          return unless object.address?

          Api::V1::Addresses::Serializer.new(
            object.address
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
