# frozen_string_literal: true

module Api
  module V1
    module Orders
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
