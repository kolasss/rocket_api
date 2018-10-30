# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'client registration', type: :request,
                                      tags: ['client registration'] do
  path '/api/v1/client/register' do
    post summary: 'sign up' do
      let(:phone) { attributes_for(:client)[:phone] }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              phone: { type: :string }
            }
          }
        }
      }
      let(:body) do
        {
          user: {
            phone: phone
          }
        }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['phone']).to eq phone
        end
        capture_example
      end
    end
  end
end
