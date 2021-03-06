# frozen_string_literal: true

FactoryBot.define do
  factory :shop, class: Shops::Shop do
    title { Faker::Restaurant.unique.name }
    description { Faker::Restaurant.description }
    minimum_order_price { 0 }

    transient do
      categories_count { 1 }
    end

    after(:create) do |shop, evaluator|
      create_list(:shop_category, evaluator.categories_count, shops: [shop])
    end

    trait :with_product do
      transient do
        pc_count { 1 }
      end

      after(:create) do |shop, evaluator|
        create_list(:product_category, evaluator.pc_count,
                    :with_product, shop: shop)
      end
    end

    trait :with_district do
      transient do
        districts_count { 1 }
        districts_array { [] }
      end

      before(:create) do |shop, evaluator|
        if evaluator.districts_array.any?
          evaluator.districts_array.each do |district|
            district.shops << shop
            district.save
          end
        else
          create_list(:district, evaluator.districts_count, shops: [shop])
        end
      end
    end
  end
end
