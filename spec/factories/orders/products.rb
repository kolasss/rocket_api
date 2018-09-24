# frozen_string_literal: true

FactoryBot.define do
  factory :order_product, class: Orders::Product do
    transient do
      shop_product { build(:product) }
    end

    title { shop_product.title }
    description { shop_product.description }
    price { shop_product.price }
    weight { shop_product.weight }
    quantity { Faker::Number.between(1, 10) }
    shop_product_id { shop_product.id }

    association :order, factory: :order
  end
end
