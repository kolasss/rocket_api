# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'couriers', type: :request, tags: ['supervisor couriers'] do
  let(:user) { create(:supervisor) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/supervisor/couriers' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    description = 'Список курьеров, готовых к работе.'
    get summary: 'list items', description: description do
      let!(:courier1) { create(:courier) }
      let!(:courier2) { create(:courier) }
      let(:precision) { 5 } # redis does not save precise values(?)
      let(:lat) do
        lat = Faker::Address.latitude
        redis_limit = 85.0 # limits for redis geo
        lat = redis_limit if lat > redis_limit
        lat = -redis_limit if lat < -redis_limit
        lat.round(precision)
      end
      let(:lon) { Faker::Address.longitude.round(precision) }

      before do
        # add courier id to redis
        id = courier1.id.to_s
        status_service = Services::CourierStatusManager.new
        status_service.add(id)
        # add courier geoposition to redis
        location_service = Services::CourierGeopositionManager.new
        location_service.add(id: id, lat: lat, lon: lon)
      end

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['id']).to eq courier1.id.to_s
          expect(items[0]['geoposition']['lat'].to_f.round(precision)).to(
            eq lat
          )
          expect(items[0]['geoposition']['lon'].to_f.round(precision)).to(
            eq lon
          )
        end
        capture_example
      end
    end
  end
end
