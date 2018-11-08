# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops categories', type: :request,
                                   tags: ['client shops_categories'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/shops_categories' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:category) { create(:shop_category) }

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
          it 'category' do
            expect(items[0]['title']).to eq category.title
          end
        end

        capture_example
      end
    end
  end

  describe 'public access' do
    let!(:category) { create(:shop_category) }

    context 'with response contains' do
      before do
        get '/api/v1/client/shops_categories'
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
      it 'category' do
        expect(items[0]['title']).to eq category.title
      end
    end
  end
end
