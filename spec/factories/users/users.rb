# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: Users::User do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.unique.phone_number }

    trait :with_code do
      code_hash { '1234' }
    end
  end
end
