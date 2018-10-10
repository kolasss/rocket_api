# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops', type: :request, tags: ['shop_manager shop'] do
  let(:shop) { create(:shop) }
  let(:user) { create(:shop_manager, shop: shop) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/shop_manager/shop' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'shows shop' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['title']).to eq shop.title
        end
        capture_example
      end
    end

    put summary: 'update an item' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_title) { 'new title' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          shop: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              category_ids: {
                type: :array,
                items: { type: :string }
              },
              minimum_order_price: { type: :number },
              district_ids: {
                type: :array,
                items: { type: :string }
              }
            }
          }
        }
      }
      let(:body) do
        { shop: { title: new_title } }
      end

      response 200, description: 'success' do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['title']).to eq new_title
        end
        capture_example
      end
    end
  end
end
