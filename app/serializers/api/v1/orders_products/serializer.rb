# frozen_string_literal: true

module Api
  module V1
    module OrdersProducts
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            description: String,
            price: BigDecimal,
            weight: String,
            quantity: Integer,
            shop_product_id: String
          }
        end

        def shop_product_id
          object.shop_product_id&.to_s
        end
      end
    end
  end
end
