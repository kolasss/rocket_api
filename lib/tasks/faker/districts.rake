# frozen_string_literal: true

require 'faker'

namespace :faker do
  desc 'generate fake districts'
  task districts: :environment do
    10.times do
      Locations::District.create!(
        title: Faker::Address.unique.community
      )
    end

    p 'Fake districts generated'
  end
end
