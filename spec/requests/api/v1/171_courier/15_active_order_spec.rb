# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'active_order', type: :request, tags: ['courier active_order'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  context 'newly assigned' do
    let!(:order) { create(:order, :requested, courier_id: user.id) }
    let!(:assignment) do
      create(
        :courier_assignment,
        courier_id: user.id,
        order: order
      )
    end

    before do
      user.update(active_order_id: order.id)
    end

    path '/api/v1/courier/active_order/accept' do
      parameter(
        :Authorization,
        in: :header,
        type: :string,
        required: true,
        description: 'Bearer token'
      )

      put summary: 'accept order' do
        produces 'application/json'

        response(200, description: 'successful') do
          it 'respond with order' do
            json = JSON.parse(response.body)
            item = json['data']
            expect(item['courierId']).to eq user.id.to_s
            expect(item['courierAssignments'][0]['courierId']).to(
              eq user.id.to_s
            )
            expect(item['courierAssignments'][0]['status']).to eq 'accepted'
          end
          capture_example
        end
      end
    end

    path '/api/v1/courier/active_order/decline' do
      parameter(
        :Authorization,
        in: :header,
        type: :string,
        required: true,
        description: 'Bearer token'
      )

      put summary: 'decline order' do
        let(:decline_reason) { 'не хочу' }
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
            reason: decline_reason
          }
        end

        response(200, description: 'successful') do
          it 'respond with order' do
            json = JSON.parse(response.body)
            item = json['data']
            expect(item['courierId']).to eq nil
            expect(item['courierAssignments'][0]['courierId']).to(
              eq user.id.to_s
            )
            expect(item['courierAssignments'][0]['status']).to eq 'declined'
            expect(item['courierAssignments'][0]['declineReason']).to(
              eq decline_reason
            )
          end
          capture_example
        end
      end
    end
  end

  path '/api/v1/courier/active_order/arrive' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    let!(:order) { create(:order, :accepted, courier_id: user.id) }

    before do
      user.update(active_order_id: order.id)
    end

    put summary: 'arrive at shop' do
      produces 'application/json'

      response(200, description: 'successful') do
        it 'respond with order' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['courierId']).to eq user.id.to_s
          expect(item['status']).to eq 'courier_at_shop'
        end
        capture_example
      end
    end
  end

  path '/api/v1/courier/active_order/pick_up' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    let!(:order) do
      create(:order, :courier_at_shop, courier_id: user.id)
    end

    before do
      user.update(active_order_id: order.id)
    end

    put summary: 'pick up order' do
      produces 'application/json'

      response(200, description: 'successful') do
        it 'respond with order' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['courierId']).to eq user.id.to_s
          expect(item['status']).to eq 'on_delivery'
        end
        capture_example
      end
    end
  end

  path '/api/v1/courier/active_order/deliver' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    let!(:order) do
      create(:order, :on_delivery, courier_id: user.id)
    end

    before do
      user.update(active_order_id: order.id)
    end

    put summary: 'deliver order' do
      produces 'application/json'

      response(200, description: 'successful') do
        it 'respond with order' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['courierId']).to eq user.id.to_s
          expect(item['status']).to eq 'delivered'
        end
        capture_example
      end
    end
  end
end
