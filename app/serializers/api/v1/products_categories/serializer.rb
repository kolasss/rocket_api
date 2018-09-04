# frozen_string_literal: true

module Api
  module V1
    module ProductsCategories
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            products: Array
          }
        end

        def products
          Api::V1::Products::Serializer.new(
            object.products
          ).build_schema
        end
      end
    end
  end
end
