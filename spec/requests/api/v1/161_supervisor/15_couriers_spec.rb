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

      before do
        # add courier id to redis
        service = Services::CourierStatusManager.new
        service.add(courier1.id)
      end

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['id']).to eq courier1.id.to_s
        end
        capture_example
      end
    end
  end
end
