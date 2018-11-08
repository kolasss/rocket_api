# frozen_string_literal: true

require 'swagger_helper'

# rubocop:disable RSpec/ScatteredSetup
RSpec.describe 'active_order', type: :request, tags: ['courier active_order'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/courier/active_order' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'show active order' do
      let(:order) { create(:order, :requested, courier_id: user.id) }

      before do
        create(
          :courier_assignment,
          courier_id: user.id,
          order: order
        )
        user.update(active_order_id: order.id)
      end

      produces 'application/json'

      response(200, description: 'successful') do
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'id' do
            expect(item['id']).to eq order.id.to_s
          end
          it 'courierId' do
            expect(item['courierId']).to eq user.id.to_s
          end
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
      let(:order) { create(:order, :requested, courier_id: user.id) }
      let(:decline_reason) { 'не хочу' }

      before do
        create(
          :courier_assignment,
          courier_id: user.id,
          order: order
        )
        user.update(active_order_id: order.id)
      end

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
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq nil
          end
          it 'courierAssignments courierId' do
            expect(item['courierAssignments'][0]['courierId']).to(
              eq user.id.to_s
            )
          end
          it 'courierAssignments status' do
            expect(item['courierAssignments'][0]['status']).to eq 'declined'
          end
          it 'courierAssignments declineReason' do
            expect(item['courierAssignments'][0]['declineReason']).to(
              eq decline_reason
            )
          end
        end

        capture_example
      end
    end
  end

  path '/api/v1/courier/active_order/accept' do
    let(:order) { create(:order, :with_accepted_shop, courier_id: user.id) }

    before do
      create(
        :courier_assignment,
        courier_id: user.id,
        order: order
      )
      user.update(active_order_id: order.id)
    end

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
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq user.id.to_s
          end
          it 'status' do
            expect(item['status']).to eq 'accepted'
          end
          it 'courierAssignments courierId' do
            expect(item['courierAssignments'][0]['courierId']).to(
              eq user.id.to_s
            )
          end
          it 'courierAssignments status' do
            expect(item['courierAssignments'][0]['status']).to eq 'accepted'
          end
        end

        capture_example
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

    let(:order) { create(:order, :accepted, courier_id: user.id) }

    before do
      user.update(active_order_id: order.id)
    end

    put summary: 'arrive at shop' do
      produces 'application/json'

      response(200, description: 'successful') do
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq user.id.to_s
          end
          it 'status' do
            expect(item['status']).to eq 'courier_at_shop'
          end
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

    let(:order) do
      create(:order, :courier_at_shop, courier_id: user.id)
    end

    before do
      user.update(active_order_id: order.id)
    end

    put summary: 'pick up order' do
      produces 'application/json'

      response(200, description: 'successful') do
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq user.id.to_s
          end
          it 'status' do
            expect(item['status']).to eq 'on_delivery'
          end
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

    let(:order) do
      create(:order, :on_delivery, courier_id: user.id)
    end

    before do
      create(:shift, courier: user)
      user.update(active_order_id: order.id)
    end

    put summary: 'deliver order' do
      produces 'application/json'

      response(200, description: 'successful') do
        context 'with response contains' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'courierId' do
            expect(item['courierId']).to eq user.id.to_s
          end
          it 'status' do
            expect(item['status']).to eq 'delivered'
          end
        end

        capture_example
      end
    end
  end
end
# rubocop:enable RSpec/ScatteredSetup
