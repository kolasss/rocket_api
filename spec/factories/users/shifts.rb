# frozen_string_literal: true

FactoryBot.define do
  factory :shift, class: Users::Couriers::Shift do
    started_at { Time.current - 1.hour }
    association :courier, factory: :courier
  end
end
