# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'client registration', type: :request,
                                      tags: ['client registration'] do
  path '/api/v1/client/register' do
    post summary: 'sign up',
         description: 'регистрация нового пользователя' do
      let(:district) { create(:district) }
      let(:item_attributes) { attributes_for(:client) }

      produces 'application/json'
      consumes 'application/json'

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
        { user: item_attributes }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['phone']).to eq item_attributes[:phone]
        end
        capture_example
      end
    end
  end
end
