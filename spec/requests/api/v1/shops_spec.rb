# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops', type: :request, tags: [:shops] do
  let(:user) { create(:user) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/shops' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:shop) { create(:shop) }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of shops' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
        end
        capture_example
      end
    end

    post summary: 'create' do
      let(:category) { create(:shop_category) }
      let(:shop_attributes) { attributes_for(:shop) }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          category_ids: {
            type: :array,
            items: { type: :string }
          }
        }
      }
      let(:body) do
        { shop: shop_attributes.merge(category_ids: [category.id.to_s]) }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          shop = json['data']
          expect(shop['title']).to eq shop_attributes[:title]
          expect(shop['categories'][0]['title']).to eq category.title
        end
        capture_example
      end
    end
  end

  path '/api/v1/shops/{shop_id}' do
    let(:shop) { create(:shop) }

    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :shop_id, in: :path, type: :string, required: true
    let(:shop_id) { shop.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
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
          title: { type: :string },
          description: { type: :string },
          category_ids: {
            type: :array,
            items: { type: :string }
          }
        }
      }
      let(:body) do
        { shop: { title: new_title } }
      end

      response 200, description: 'success' do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          shop = json['data']
          expect(shop['title']).to eq new_title
        end
        capture_example
      end
    end

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end