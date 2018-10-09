# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: Orders::Order do
    status { 'new' }
    price_total { 0 }

    association :client, factory: :client
    association :shop, factory: :shop

    after(:build) do |order|
      build(:shop_response, order: order)
    end

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

    trait :requested do
      status { 'requested' }
    end

    trait :accepted do
      status { 'accepted' }
    end

    trait :courier_at_shop do
      status { 'courier_at_shop' }
    end

    trait :on_delivery do
      status { 'on_delivery' }
    end

    trait :with_accepted_assignment do
      requested
      after(:build) do |order|
        assignment = build(:courier_assignment, :accepted, order: order)
        order.courier_id = assignment.courier_id
      end
    end

    trait :with_accepted_shop do
      requested
      after(:build) do |order|
        order.shop_response.status = 'accepted'
      end
    end
  end
end
