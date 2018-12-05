# frozen_string_literal: true

require 'swagger_helper'

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe 'token', type: :request, tags: ['user firebase token'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/users/token' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    put summary: 'update' do
      consumes 'application/json'

      let(:token_key) { 'asdf123' }
      let(:platform) { 'android' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          token: {
            type: :object,
            properties: {
              key: { type: :string },
              platform: { type: :string }
            }
          }
        }
      }
      let(:body) do
        {
          token: {
            key: token_key,
            platform: platform
          }
        }
      end

      response 204, description: 'success' do
        capture_example
      end
    end
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
