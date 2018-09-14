# frozen_string_literal: true

FactoryBot.define do
  factory :shop, class: Shops::Shop do
    title { Faker::Restaurant.unique.name }
    description { Faker::Restaurant.description }

    # association :categories, factory: :shop_category
    before :create do |shop|
      shop.categories << create(:shop_category)
      # create_list :comment, 3, post: post   # has_many
    end
  end
end
