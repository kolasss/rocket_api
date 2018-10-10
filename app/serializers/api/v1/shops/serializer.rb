# frozen_string_literal: true

module Api
  module V1
    module Shops
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            description: String,
            categories: Array,
            districts: Array,
            # time: String,
            products_categories: Array
          }
        end

        # def time
        #   Time.current.rfc3339
        # end

        def categories
          # object.categories.map do |category|
          # object.categories.pluck(:_id, :title).map do |category|
          # object.categories.only(:_id, :title).map do |category|
          #   serializer = Api::V1::ShopsCategories::CompactSerializer
          #   # serializer = CategoriesSerializer
          #   serializer.new(category).build_schema
          # end
          # serializer = Api::V1::ShopsCategories::CompactSerializer
          Api::V1::ShopsCategories::CompactSerializer.new(
            object.categories.only(:_id, :title)
          ).build_schema
          # Surrealist.surrealize_collection(
          #   object.categories.only(:_id, :title),
          #   serializer: CategoriesSerializer,
          #   raw: true
          # )
        end

        def districts
          Api::V1::Districts::Serializer.new(
            object.districts.only(:_id, :title)
          ).build_schema
        end

        def products_categories
          Api::V1::ProductsCategories::Serializer.new(
            object.products_categories
          ).build_schema
        end
      end
    end
  end
end
