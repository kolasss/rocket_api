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
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:items) { json['data']['items'] }

          it 'array' do
            expect(items).to be_an_instance_of(Array)
          end
          it '1 item' do
            expect(items.size).to eq 1
          end
          it 'order' do
            expect(items[0]['id']).to eq order.id.to_s
          end
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
    let(:order) { create(:order, status: 'requested') }
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
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq new_courier.id.to_s
          end
          it 'courierAssignments is array' do
            expect(item['courierAssignments']).to be_an_instance_of(Array)
          end
          it 'courierAssignments contains 1 item' do
            expect(item['courierAssignments'].size).to eq 1
          end
          it 'courierAssignments has status proposed' do
            expect(item['courierAssignments'][0]['status']).to eq 'proposed'
          end
        end

        capture_example
      end
    end
  end
end
