# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops', type: :request, tags: ['client shops'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/shops' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    description = 'send query parameter district_id'
    get summary: 'list items', description: description do
      let!(:shop) do
        create(:shop, :with_district)
      end

      parameter :district_id, in: :query, type: :string, required: true
      let(:district) { shop.districts.first }
      let(:district_id) { district.id.to_s }

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
          it 'shop' do
            expect(items[0]['title']).to eq shop.title
          end
          it 'shop\'s district' do
            expect(items[0]['districtIds']).to eq [district_id]
          end
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

  describe 'public access' do
    let!(:shop) { create(:shop, :with_district) }
    let(:district) { shop.districts.first }
    let(:district_id) { district.id.to_s }
    let(:shop_id) { shop.id.to_s }

    context 'when get index response contains' do
      before do
        get "/api/v1/client/shops?district_id=#{district_id}"
      end

      let(:json) { JSON.parse(response.body) }
      let(:items) { json['data']['items'] }

      it 'status is ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'array' do
        expect(items).to be_an_instance_of(Array)
      end
      it '1 item' do
        expect(items.size).to eq 1
      end
      it 'shop' do
        expect(items[0]['title']).to eq shop.title
      end
      it 'shop\'s district' do
        expect(items[0]['districtIds']).to eq [district_id]
      end
    end

    context 'when get show' do
      it 'allowed' do
        get "/api/v1/client/shops/#{shop_id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
