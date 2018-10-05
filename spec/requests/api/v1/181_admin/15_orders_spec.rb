# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders', type: :request, tags: ['admin orders'] do
  let(:user) { create(:admin) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/admin/orders' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:order) { create(:order) }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of orders' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
        end
        capture_example
      end
    end

    post summary: 'create' do
      let(:shop) { create(:shop, :with_product) }
      let(:item_attributes) { attributes_for(:order) }
      # let(:product) { shop.products_categories.first.products.first }
      # let(:quantity) { 2 }
      let(:client) { create(:client) }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              client_id: { type: :string },
              courier_id: { type: :string },
              shop_id: { type: :string },
              status: { type: :string },
              # products: {
              #   type: :array,
              #   items: {
              #     type: :object,
              #     properties: {
              #       id: { type: :string },
              #       quantity: {
              #         type: :integer,
              #         minimum: 1
              #       }
              #     }
              #   }
              # }
            }
          }
        }
      }
      let(:body) do
        {
          order: item_attributes.merge(
            client_id: client.id.to_s,
            shop_id: shop.id.to_s,
            status: 'new'
            # products: [
            #   {
            #     id: product.id.to_s,
            #     quantity: quantity
            #   }
            # ]
          )
        }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['shopId']).to eq shop.id.to_s
          expect(item['clientId']).to eq client.id.to_s
          # expect(item['products'][0]['title']).to eq product.title
          # expect(item['priceTotal']).to eq(product.price * quantity)
        end
        capture_example
      end
    end
  end

  path '/api/v1/admin/orders/{order_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :with_product) }
    let(:order_id) { order.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'shows right info' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['priceTotal']).to be_positive
        end
        capture_example
      end
    end

    put summary: 'update an item' do
      let(:new_courier) { create(:courier) }
      let(:new_status) { 'delivered' }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          order: {
            type: :object,
            properties: {
              client_id: { type: :string },
              courier_id: { type: :string },
              shop_id: { type: :string },
              status: { type: :string }
            }
          }
        }
      }
      let(:body) do
        {
          order: {
            courier_id: new_courier.id.to_s,
            status: new_status
          }
        }
      end

      response 200, description: 'success' do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['status']).to eq new_status
          expect(item['courierId']).to eq new_courier.id.to_s
        end
        capture_example
      end
    end

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end
