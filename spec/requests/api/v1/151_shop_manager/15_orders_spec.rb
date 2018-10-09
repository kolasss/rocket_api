# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders', type: :request, tags: ['shop_manager orders'] do
  let(:user) { create(:shop_manager) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }
  let(:shop) { user.shop }

  path '/api/v1/shop_manager/orders' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:order) { create(:order, shop: shop) }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of orders' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['shopId']).to eq shop.id.to_s
        end
        capture_example
      end
    end
  end

  path '/api/v1/shop_manager/orders/{order_id}/accept' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :with_accepted_assignment, shop: shop) }
    let(:order_id) { order.id.to_s }

    put summary: 'accept order' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'changes order status to accepted' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['shopResponse']['status']).to eq 'accepted'
          expect(item['status']).to eq 'accepted'
        end

        capture_example
      end
    end
  end

  path '/api/v1/shop_manager/orders/{order_id}/cancel' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :requested, shop: shop) }
    let(:order_id) { order.id.to_s }
    let(:reason) { 'нет света' }

    put summary: 'cancel order' do
      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          reason: { type: :string }
        }
      }
      let(:body) do
        {
          reason: reason
        }
      end

      response(200, description: 'success') do
        it 'changes order status to canceled_shop' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['shopResponse']['status']).to eq 'canceled'
          expect(item['status']).to eq 'canceled_shop'
        end

        capture_example
      end
    end
  end
end
