# frozen_string_literal: true

module Api
  module V1
    module Orders
      class Serializer < BasicSerializer
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
            cancel_reason: String,
            address: Hash,
            created_at: String,
            updated_at: String,
            number: Integer
          }
        end
      end
    end
  end
end
