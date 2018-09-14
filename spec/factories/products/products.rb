# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: Products::Product do
    title { Faker::Restaurant.unique.type }
    description { Faker::Food.description }
    price { Faker::Number.decimal(3, 2) }
    weight { Faker::Measurement.metric_weight }

    association :category, factory: :product_category
  end
end
