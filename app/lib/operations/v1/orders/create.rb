# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Operations
  module V1
    module Orders
      class Create < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        VALIDATOR = Dry::Validation.Schema do
          required(:order).schema do
            required(:shop_id).filled(:str?)
            required(:products) do
              filled? do
                each do
                  schema do
                    required(:id).filled(:str?)
                    required(:quantity).filled(:int?, gteq?: 1)
                  end
                end
              end
            end
          end
        end

        # rubocop:disable Metrics/AbcSize
        def call(params:, client:)
          payload = yield VALIDATOR.call(params).to_monad
          yield check_products_uniqueness(payload[:order][:products])
          shop = yield find_shop(payload[:order][:shop_id])
          order = yield initialize_order(
            shop: shop,
            client: client,
            products_params: payload[:order][:products]
          )
          yield check_total_price(order.price_total, shop.minimum_order_price)
          save_order(order)
        end
        # rubocop:enable Metrics/AbcSize

        private

        def check_products_uniqueness(products_params)
          products_ids = []
          products_params.each do |product|
            if products_ids.include? product[:id]
              return Failure(:products_ids_should_be_uniq)
            end

            products_ids << product[:id]
          end
          Success(true)
        end

        def find_shop(shop_id)
          shop = ::Shops::Shop.where(id: shop_id).first
          if shop.present?
            Success(shop)
          else
            Failure(:shop_not_found)
          end
        end

        def initialize_order(shop:, client:, products_params:)
          order = ::Orders::Order.new(
            shop: shop,
            client: client,
            status: 'new'
          )

          initialize_products(order, products_params)
          return Failure(:products_not_found) unless order.has_products?

          count_total_price(order)
          initialize_shop_response(order)

          Success(order)
        end

        def check_total_price(price, minimum)
          return Success(true) if minimum.blank?

          return Failure(:order_price_too_low) if price < minimum

          Success(true)
        end

        def save_order(order)
          if order.save
            Success(order)
          else
            Failure(order: order.errors.as_json)
          end
        end

        def initialize_products(order, products_params)
          shop_products = order.shop.products_categories.map(&:products).flatten
          shop_products.each do |shop_product|
            products_params.delete_if do |param_product|
              check_product_and_initialize(order, shop_product, param_product)
            end
          end
        end

        def check_product_and_initialize(order, shop_product, param_product)
          product_matches = shop_product.id.to_s == param_product[:id]
          if product_matches
            order.products.new(
              title: shop_product[:title],
              # image: shop_product[:image],
              description: shop_product[:description],
              price: shop_product[:price],
              weight: shop_product[:weight],
              shop_product_id: shop_product[:id],
              quantity: param_product[:quantity]
            )
          end
          product_matches
        end

        def count_total_price(order)
          order.price_total = order.products.reduce(0.0) do |total, product|
            total + (product.price * product.quantity)
          end
        end

        def initialize_shop_response(order)
          order.build_shop_response(
            status: 'requested'
          )
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
