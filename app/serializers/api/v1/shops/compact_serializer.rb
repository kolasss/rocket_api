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
            category_ids: Array
            # categories: Array
          }
        end

        def category_ids
          object.category_ids.map(&:to_s)
        end

        # def categories
        #   Api::V1::ShopsCategories::CompactSerializer.new(
        #     # object.categories.only(:_id, :title)
        #     object.categories
        #   ).build_schema
        # end
      end
    end
  end
end
