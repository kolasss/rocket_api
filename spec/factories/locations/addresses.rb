# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: Locations::Address do
    title { Faker::Address.community }
    street { Faker::Address.street_name }
    building { Faker::Address.building_number }
    apartment { Faker::Address.secondary_address }
    entrance { Faker::Number.number(1) }
    floor { Faker::Number.number(1) }
    intercom { Faker::Number.number(3) }
    note { Faker::TvShows::GameOfThrones.quote }
    location do
      {
        lat: Faker::Address.latitude,
        lon: Faker::Address.longitude
      }
    end
  end
end
