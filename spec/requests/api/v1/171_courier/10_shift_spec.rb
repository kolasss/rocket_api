# frozen_string_literal: true

require 'swagger_helper'

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe 'shift', type: :request, tags: ['courier shift'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/courier/shift' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    description = %(Сообщение серверу о то что курьер начал смену)
    post summary: 'set status to online', description: description do
      let(:user) { create(:courier, status: 'offline') }

      produces 'application/json'

      response(201, description: 'successful') do
        capture_example
      end
    end

    put summary: 'set status to offline' do
      before { create(:shift, courier: user) }

      produces 'application/json'

      response(204, description: 'successful') do
        capture_example
      end
    end
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
