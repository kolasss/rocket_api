# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'client authentication', type: :request,
                                        tags: ['client authentication'] do
  path '/api/v1/client/login' do
    let(:user) { create(:client, :with_code) }

    post summary: 'sign in',
         description: 'получение токена' do
      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              phone: { type: :string },
              code: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { user: {
          phone: user.phone,
          code: '1234'
        } }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          item = json['data']
          expect(item['token']).to be_truthy
        end
        capture_example
      end
    end
  end
end
