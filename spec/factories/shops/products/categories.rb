# frozen_string_literal: true

FactoryBot.define do
  factory :product_category, class: Shops::Products::Category do
    title { Faker::Restaurant.unique.type }

    association :shop, factory: :shop

    trait :with_product do
      transient do
        products_count { 1 }
      end

      after(:create) do |category, evaluator|
        create_list(:product, evaluator.products_count, category: category)
      end
    end
  end
end
