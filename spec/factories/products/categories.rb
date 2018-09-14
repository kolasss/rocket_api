# frozen_string_literal: true

FactoryBot.define do
  factory :product_category, class: Products::Category do
    title { Faker::Restaurant.unique.type }

    association :shop, factory: :shop
  end
end
