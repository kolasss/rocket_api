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
            products: Array
          }
        end

        def products
          Api::V1::OrdersProducts::Serializer.new(
            object.products
          ).build_schema
        end

        def client_id
          object.client_id.to_s
        end

        def courier_id
          object.courier_id.to_s
        end

        def shop_id
          object.shop_id.to_s
        end
      end
    end
  end
end
