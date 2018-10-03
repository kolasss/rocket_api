# frozen_string_literal: true

FactoryBot.define do
  factory :courier_assignment, class: Orders::CourierAssignment do
    courier_id { create(:courier).id }
    status { 'proposed' }

    association :order, factory: :order
  end
end
