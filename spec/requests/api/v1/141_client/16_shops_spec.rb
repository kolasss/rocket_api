# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops', type: :request, tags: ['client shops'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/shops?district_id={district_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:shop) do
        create(:shop, :with_district)
      end

      parameter :district_id, in: :path, type: :string, required: true
      let(:district) { shop.districts.first }
      let(:district_id) { district.id.to_s }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of shops' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['title']).to eq shop.title
          expect(items[0]['districtIds']).to eq [district.id.to_s]
        end
        capture_example
      end
    end
  end

  path '/api/v1/client/shops/{shop_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :shop_id, in: :path, type: :string, required: true
    let(:shop) { create(:shop) }
    let(:shop_id) { shop.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        capture_example
      end
    end
  end
end
