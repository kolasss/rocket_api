# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'products_categories', type: :request,
                                      tags: [:products_categories] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }
  let(:shop) { create(:shop) }
  let(:shop_id) { shop.id.to_s }

  path '/api/v1/shops/{shop_id}/products_categories' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :shop_id, in: :path, type: :string, required: true

    post summary: 'create',
         description: 'создает новую категорию товаров для магазина' do
      let(:item_attributes) { attributes_for(:product_category) }

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

  path '/api/v1/shops/{shop_id}/products_categories/{category_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :shop_id, in: :path, type: :string, required: true

    parameter :category_id, in: :path, type: :string, required: true
    let(:category) { create(:product_category, shop: shop) }
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
