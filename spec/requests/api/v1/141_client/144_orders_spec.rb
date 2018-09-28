# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders', type: :request, tags: ['client orders'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/orders' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:order) { create(:order, client: user) }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of orders' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['clientId']).to eq user.id.to_s
        end
        capture_example
      end
    end

    post summary: 'create' do
      let(:shop) { create(:shop, :with_product) }
      let(:item_attributes) { attributes_for(:order) }
      let(:product) { shop.products_categories.first.products.first }
      let(:product_quantity) { 2 }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              shop_id: { type: :string },
              products: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :string },
                    quantity: {
                      type: :integer,
                      minimum: 1
                    }
                  }
                }
              }
            }
          }
        }
      }
      let(:body) do
        {
          order: item_attributes.merge(
            shop_id: shop.id.to_s,
            products: [
              {
                id: product.id.to_s,
                quantity: product_quantity
              }
            ]
          )
        }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['shopId']).to eq shop.id.to_s
          expect(item['clientId']).to eq user.id.to_s
          expect(item['status']).to eq 'new'
          expect(item['products'][0]['title']).to eq product.title
          expect(item['priceTotal']).to eq(product.price * product_quantity)
        end
        capture_example
      end
    end
  end

  path '/api/v1/client/orders/{order_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :with_product, client: user) }
    let(:order_id) { order.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'shows right info' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['clientId']).to eq user.id.to_s
          expect(item['priceTotal']).to be_positive
        end
        capture_example
      end
    end
  end

  # path '/api/v1/client/orders/{order_id}/cancel' do
  #   parameter(
  #     :Authorization,
  #     in: :header,
  #     type: :string,
  #     required: true,
  #     description: 'Bearer token'
  #   )

  #   parameter :order_id, in: :path, type: :string, required: true
  #   let(:order) { create(:order, :with_product, client: user) }
  #   let(:order_id) { order.id.to_s }

  #   put summary: 'fetch an item' do
  #     produces 'application/json'

  #     response(200, description: 'success') do
  #       it 'shows right info' do
  #         json = JSON.parse(response.body)
  #         item = json['data']
  #         expect(item['clientId']).to eq user.id.to_s
  #         expect(item['priceTotal']).to be > 0
  #       end
  #       capture_example
  #     end
  #   end
  # end
end
