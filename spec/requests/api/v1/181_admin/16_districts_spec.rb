# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'districts', type: :request,
                            tags: ['admin districts'] do
  let(:user) { create(:admin) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/admin/districts' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:district) { create(:district) }

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
          it 'district' do
            expect(items[0]['title']).to eq district.title
          end
        end

        capture_example
      end
    end

    post summary: 'create' do
      let(:item_attributes) { attributes_for(:district) }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          district: {
            type: :object,
            properties: {
              title: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { district: item_attributes }
      end

      response(201, description: 'successfully created') do
        it 'uses the params to create' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['title']).to eq item_attributes[:title]
        end
        capture_example
      end
    end
  end

  path '/api/v1/admin/districts/{district_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :district_id, in: :path, type: :string, required: true
    let(:district) { create(:district) }
    let(:district_id) { district.id.to_s }

    put summary: 'update an item' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_title) { 'new title' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          district: {
            type: :object,
            properties: {
              title: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { district: { title: new_title } }
      end

      response 200, description: 'success' do
        it 'uses the params to update' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['title']).to eq new_title
        end
        capture_example
      end
    end

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end
