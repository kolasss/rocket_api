# frozen_string_literal: true

require 'faker'

namespace :faker do
  desc 'generate fake shops with products'
  task shops: :environment do
    10.times do
      ShopsFaker.generate_category
    end
    100.times do
      ShopsFaker.generate_shop
    end

    shops = Shops::Shop.all
    shops.each do |shop|
      ShopsFaker.generate_products_for(shop)
    end

    p 'Fake shops generated'
  end
end

module ShopsFaker
  @prng = Random.new

  class << self
    def generate_category
      Shops::Category.create!(
        title: Faker::Restaurant.unique.type
      )
    end

    def generate_shop
      shop = Shops::Shop.create!(
        title: Faker::Restaurant.unique.name,
        description: Faker::Restaurant.description,
        districts: random_districts
      )
      @prng.rand(1..2).times do
        shop.categories << Shops::Category.all.sample
      end
    end

    def generate_products_for(shop)
      @prng.rand(2..3).times do
        category = generate_product_category_for(shop)
        @prng.rand(5..20).times do
          generate_product_for(category)
        end
      end
      Faker::UniqueGenerator.clear
    end

    private

    def generate_product_category_for(shop)
      shop.products_categories.create!(
        title: Faker::Cannabis.unique.category
      )
    end

    def generate_product_for(category)
      category.products.create!(
        title: Faker::Food.dish,
        description: Faker::Food.description,
        price: Faker::Number.decimal(3, 2),
        weight: Faker::Measurement.metric_weight
      )
    end

    def random_districts
      Locations::District.all.sample(@prng.rand(1..2))
    end
  end
end
