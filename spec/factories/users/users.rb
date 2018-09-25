# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: Users::User do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.unique.phone_number }
    role { 'client' }

    trait :with_code do
      code_hash { '1234' }
    end

    trait :shop_manager do
      role { 'shop_manager' }
      association :shop, factory: :shop
    end
  end
end
