# frozen_string_literal: true

module Api
  module V1
    module Products
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            description: String,
            price: BigDecimal,
            weight: String,
            image: Array
          }
        end

        def image
          return if object.image.blank?

          object.image.map { |version, file| { version => file.url } }
        end
      end
    end
  end
end
