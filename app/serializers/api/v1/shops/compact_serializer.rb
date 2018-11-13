# frozen_string_literal: true

module Api
  module V1
    module Shops
      class CompactSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            description: String,
            category_ids: Array,
            district_ids: Array,
            image: Array,
            logo: Array
          }
        end

        def category_ids
          object.category_ids.map(&:to_s)
        end

        def district_ids
          object.district_ids.map(&:to_s)
        end

        def image
          image_json(object.image)
        end

        def logo
          image_json(object.logo)
        end
      end
    end
  end
end
