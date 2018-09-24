# frozen_string_literal: true

module Api
  module V1
    module Products
      class Serializer < Api::V1::ObjectSerializer
        PRODUCT_FIELDS = {
          id: String,
          title: String,
          description: String,
          price: BigDecimal,
          weight: String
        }.freeze

        json_schema do
          PRODUCT_FIELDS
        end
      end
    end
  end
end
