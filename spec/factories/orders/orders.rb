# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: Orders::Order do
    status { 'new' }
    price_total { 0 }

    association :client, factory: :client
    association :shop, factory: :shop, strategy: :build

    trait :with_product do
      transient do
        products_count { 1 }
      end

      association :shop, factory: %i[shop with_product]

      after(:create) do |order, evaluator|
        create_list(
          :order_product, evaluator.products_count,
          shop_product: order.shop.products_categories.first.products.first,
          order: order
        )
        price_total = order.products.reduce(0.0) do |total, product|
          total + (product.price * product.quantity)
        end
        order.update(price_total: price_total)
      end
    end
  end
end
