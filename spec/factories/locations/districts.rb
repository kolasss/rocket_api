# frozen_string_literal: true

FactoryBot.define do
  factory :district, class: Locations::District do
    title { Faker::Address.unique.community }
  end
end
