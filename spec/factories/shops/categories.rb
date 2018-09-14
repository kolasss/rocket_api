# frozen_string_literal: true

FactoryBot.define do
  factory :shop_category, class: Shops::Category do
    title { Faker::Restaurant.unique.type }
  end
end
