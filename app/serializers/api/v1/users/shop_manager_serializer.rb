# frozen_string_literal: true

module Api
  module V1
    module Users
      class ShopManagerSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            name: String,
            phone: String,
            role: String,
            shop_id: String
          }
        end

        def role
          'shop_manager'
        end

        def shop_id
          object.shop_id&.to_s
        end
      end
    end
  end
end
