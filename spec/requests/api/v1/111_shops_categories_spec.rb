# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops categories', type: :request, tags: [:shops_categories] do
  let(:user) { create(:user) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/shops_categories' do
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
        it 'contains array of categories' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['title']).to eq category.title
        end
        capture_example
      end
    end

    post summary: 'create' do
      let(:item_attributes) { attributes_for(:shop_category) }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              title: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { category: item_attributes }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['title']).to eq item_attributes[:title]
        end
        capture_example
      end
    end
  end

  path '/api/v1/shops_categories/{category_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :category_id, in: :path, type: :string, required: true
    let(:category) { create(:shop_category) }
    let(:category_id) { category.id.to_s }

    put summary: 'update an item' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_title) { 'new title' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              title: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { category: { title: new_title } }
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

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end
