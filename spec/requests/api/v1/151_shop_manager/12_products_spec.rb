# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'products', type: :request,
                           tags: ['shop_manager products'] do
  let(:shop) { create(:shop) }
  let(:user) { create(:shop_manager, shop: shop) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }
  let(:category) { create(:product_category, shop: shop) }
  let(:category_id) { category.id.to_s }

  path '/api/v1/shop_manager/shop/products_categories/{category_id}/products' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :category_id, in: :path, type: :string, required: true

    description = %(создает новую товар в данной категории, image has type file)
    post summary: 'create', description: description do
      let(:item_attributes) { attributes_for(:product) }

      produces 'application/json'
      consumes 'application/json', 'multipart/form-data'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              weight: { type: :string },
              image: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { product: item_attributes }
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

  path '/api/v1/shop_manager/shop/products_categories/{category_id}/products/{product_id}' do # rubocop:disable Metrics/LineLength
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :category_id, in: :path, type: :string, required: true

    parameter :product_id, in: :path, type: :string, required: true
    let(:product) { create(:product, category: category) }
    let(:product_id) { product.id.to_s }

    description = %(image has type file)
    put summary: 'update an item', description: description do
      produces 'application/json'
      consumes 'application/json', 'multipart/form-data'

      let(:new_title) { 'new title' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              weight: { type: :string },
              image: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { product: { title: new_title } }
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
