# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: Users::User do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.unique.phone_number }

    factory :client, class: Users::Client do
      trait :with_code do
        code_hash { '1234' }
      end

      trait :with_address do
        transient do
          addresses_count { 1 }
        end

        after(:create) do |user, evaluator|
          create_list(:address, evaluator.addresses_count, addressable: user)
        end
      end
    end

    factory :shop_manager, class: Users::ShopManager do
      association :shop, factory: :shop
    end

    factory :courier, class: Users::Courier do
    end

    factory :supervisor, class: Users::Supervisor do
    end

    factory :admin, class: Users::Admin do
    end

    trait :with_password do
      password_hash { '1234' }
    end
  end
end
