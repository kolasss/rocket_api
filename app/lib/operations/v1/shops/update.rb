# frozen_string_literal: true

module Operations
  module V1
    module Shops
      class Update < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        VALIDATOR = Dry::Validation.Schema do
          required(:shop).schema do
            optional(:title).filled(:str?)
            optional(:description).filled(:str?)
            optional(:minimum_order_price).value(
              :filled?, :numeric?, gteq?: 0
            )
            optional(:category_ids).value(min_size?: 1) { each(:str?) }
            optional(:district_ids).value(min_size?: 1) { each(:str?) }
            optional(:address).schema do
              optional(:title).filled(:str?)
              optional(:street).filled(:str?)
              optional(:building).filled(:str?)
              optional(:apartment).filled(:str?)
              optional(:entrance).filled(:str?)
              optional(:floor).filled(:str?)
              optional(:intercom).filled(:str?)
              optional(:note).filled(:str?)
              optional(:location).schema do
                required(:lat).filled(:float?)
                required(:lon).filled(:float?)
              end
            end
            optional(:image).filled(:file?)
            optional(:logo).filled(:file?)
          end
        end

        def call(params:, shop:)
          payload = yield VALIDATOR.call(params).to_monad
          yield validate_categories(payload[:shop][:category_ids])
          yield validate_districts(payload[:shop][:district_ids])
          yield update_address(shop, payload[:shop][:address])
          update_shop(shop, payload[:shop].except(:address))
        end

        private

        def validate_categories(category_ids)
          return Success(true) if category_ids.blank?

          count = ::Shops::Category.in(id: category_ids).count
          if count == category_ids.count
            Success(true)
          else
            Failure(:invalid_category_ids)
          end
        end

        def validate_districts(district_ids)
          return Success(true) if district_ids.blank?

          count = ::Locations::District.in(id: district_ids).count
          if count == district_ids.count
            Success(true)
          else
            Failure(:invalid_district_ids)
          end
        end

        def update_address(shop, address_params)
          return Success(true) if address_params.blank?

          address = shop.address || shop.build_address
          address.assign_attributes(address_params)
          Success(true)
        end

        def update_shop(shop, shop_params)
          # binding.pry
          # Rails.logger.warn shop_params
          shop.assign_attributes(shop_params)

          if shop.save
            Success(shop)
          else
            Failure(shop: shop.errors.as_json)
          end
        end
      end
    end
  end
end
