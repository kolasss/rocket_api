# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'orders', type: :request, tags: ['courier orders'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/courier/orders' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list orders' do
      let(:order) { create(:order, :requested, courier_id: user.id) }
      before do
        create(
          :courier_assignment,
          courier_id: user.id,
          order: order
        )
      end

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
          it 'courierId' do
            expect(items[0]['courierId']).to eq user.id.to_s
          end
        end

        capture_example
      end
    end
  end

  path '/api/v1/courier/orders/{order_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :order_id, in: :path, type: :string, required: true
    let(:order) { create(:order, :requested, courier_id: user.id) }
    let(:order_id) { order.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'shows right info' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['courierId']).to eq user.id.to_s
        end
        capture_example
      end
    end
  end
end
