# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'users', type: :request, tags: [:users] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/users' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of users' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['name']).to eq user.name
        end
        capture_example
      end
    end

    post summary: 'create' do
      let(:item_attributes) { attributes_for(:user) }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              phone: { type: :string },
              # role: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { user: item_attributes }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['name']).to eq item_attributes[:name]
        end
        capture_example
      end
    end
  end

  path '/api/v1/users/{user_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :user_id, in: :path, type: :string, required: true
    let(:user2) { create(:client) }
    let(:user_id) { user2.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        capture_example
      end
    end

    put summary: 'update an item' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_name) { 'new name' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              phone: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { user: { name: new_name } }
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

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end
