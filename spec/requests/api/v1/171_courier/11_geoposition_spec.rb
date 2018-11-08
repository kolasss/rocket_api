# frozen_string_literal: true

require 'swagger_helper'

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe 'geoposition', type: :request, tags: ['courier geoposition'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/courier/geoposition' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    let(:lat) do
      lat = Faker::Address.latitude
      # limits for redis geo
      lat = 85.0 if lat > 85.0
      lat = -85.0 if lat < -85.0
      lat
    end
    let(:lon) { Faker::Address.longitude }

    description = %(Обновление геопозиции курьера.
Ожидается минимум 1 запрос в 10 минут.)
    post summary: 'update geoposition', description: description do
      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          lat: { type: :number },
          lon: { type: :number }
        }
      }
      let(:body) do
        {
          lat: lat,
          lon: lon
        }
      end

      response(204, description: 'successful') do
        capture_example
      end
    end
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
