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
            products_categories: Array,
            address: Hash,
            minimum_order_price: BigDecimal,
            image: Array,
            logo: Array
          }
        end

        # def time
        #   Time.current.rfc3339
        # end

        def categories
          Api::V1::ShopsCategories::CompactSerializer.new(
            object.categories.only(:_id, :title)
          ).build_schema
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

        def address
          return unless object.address?

          Api::V1::Addresses::Serializer.new(
            object.address
          ).build_schema
        end

        def image
          return if object.image.blank?

          object.image.map { |version, file| { version => file.url } }
        end

        def logo
          return if object.logo.blank?

          object.logo.map { |version, file| { version => file.url } }
        end
      end
    end
  end
end
