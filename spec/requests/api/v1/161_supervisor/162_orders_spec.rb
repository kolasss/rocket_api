# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders', type: :request, tags: ['supervisor orders'] do
  let(:user) { create(:supervisor) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/supervisor/orders' do
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
  end

  path '/api/v1/supervisor/orders/{order_id}' do
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
        capture_example
      end
    end
  end

  path '/api/v1/supervisor/orders/{order_id}/assign_courier' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :with_product, status: 'requested') }
    let(:order_id) { order.id.to_s }
    let(:new_courier) { create(:courier) }

    post summary: 'assign courier to order' do
      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          courier_id: { type: :string }
        }
      }
      let(:body) do
        {
          courier_id: new_courier.id.to_s
        }
      end

      response(200, description: 'success') do
        it 'shows right info' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['courierId']).to eq new_courier.id.to_s
          expect(item['courierAssignments']).to be_an_instance_of(Array)
          expect(item['courierAssignments'].size).to eq 1
          expect(item['courierAssignments'][0]['status']).to eq 'proposed'
        end
        capture_example
      end
    end
  end
end
