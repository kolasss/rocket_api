# frozen_string_literal: true

module Api
  module V1
    module Orders
      class BasicSerializer < Api::V1::ObjectSerializer
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

        def client_id
          object.client_id&.to_s
        end

        def courier_id
          object.courier_id&.to_s
        end

        def shop
          Api::V1::Shops::OrderSerializer.new(
            object.shop
          ).build_schema
        end

        def shop_id
          object.shop_id&.to_s
        end

        def courier_assignments
          Api::V1::Orders::CourierAssignmentSerializer.new(
            object.courier_assignments
          ).build_schema
        end

        def shop_response
          return unless object.shop_response?

          Api::V1::Orders::ShopResponseSerializer.new(
            object.shop_response
          ).build_schema
        end

        def address
          return unless object.address?

          Api::V1::Addresses::Serializer.new(
            object.address
          ).build_schema
        end

        def created_at
          object.created_at.rfc3339
        end

        def updated_at
          object.updated_at.rfc3339
        end
      end
    end
  end
end
