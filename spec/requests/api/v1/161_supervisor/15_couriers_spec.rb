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
      let(:courier1) { create(:courier) }
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
        create(:courier) # should not be inlcuded in response
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
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:items) { json['data']['items'] }

          it 'array' do
            expect(items).to be_an_instance_of(Array)
          end
          it '1 item' do
            expect(items.size).to eq 1
          end
          it 'courier\'s id' do
            expect(items[0]['id']).to eq courier1.id.to_s
          end
          it 'courier\'s lat' do
            expect(items[0]['geoposition']['lat'].to_f.round(precision)).to(
              eq lat
            )
          end
          it 'courier\'s lon' do
            expect(items[0]['geoposition']['lon'].to_f.round(precision)).to(
              eq lon
            )
          end
        end

        capture_example
      end
    end
  end
end
