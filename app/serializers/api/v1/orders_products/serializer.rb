# frozen_string_literal: true

module Api
  module V1
    module OrdersProducts
      class Serializer < Api::V1::Products::Serializer
        json_schema do
          PRODUCT_FIELDS.merge(
            quantity: Integer,
            shop_product_id: String
          )
        end

        def shop_product_id
          object.shop_product_id.to_s
        end
      end
    end
  end
end
