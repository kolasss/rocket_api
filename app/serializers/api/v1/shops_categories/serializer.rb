# frozen_string_literal: true

module Api
  module V1
    module ShopsCategories
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            shop_ids: Array
          }
        end

        def shop_ids
          object.shop_ids.map(&:to_s)
        end
      end
    end
  end
end
