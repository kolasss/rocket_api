# frozen_string_literal: true

FactoryBot.define do
  factory :shop_response, class: Orders::ShopResponse do
    status { 'requested' }

    association :order, factory: :order
  end
end
