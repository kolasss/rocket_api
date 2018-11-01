# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'profile', type: :request, tags: ['user profile'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/users/profile' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        it 'shows user' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['name']).to eq user.name
        end
        capture_example
      end
    end

    put summary: 'update' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_name) { 'new name' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        }
      }
      let(:body) do
        {
          user: {
            name: new_name
          }
        }
      end

      response 200, description: 'success' do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['name']).to eq new_name
        end
        capture_example
      end
    end
  end
end
