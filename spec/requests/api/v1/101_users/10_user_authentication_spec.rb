# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'user authentication', type: :request,
                                      tags: ['user authentication'] do
  path '/api/v1/users/login' do
    let(:user) { create(:shop_manager, :with_password) }

    description = %(Получение токена, требуются пароль и роль пользователя.
Для логина по паролю supervisor, courier, admin, shop_manager.
Для логина client используйте client authentication)
    post summary: 'sign in', description: description do
      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              phone: { type: :string },
              password: { type: :string },
              role: {
                type: :string,
                enum: %w[
                  supervisor
                  courier
                  admin
                  shop_manager
                ]
              }
            }
          }
        }
      }
      let(:body) do
        { user: {
          phone: user.phone,
          password: '1234',
          role: 'shop_manager'
        } }
      end

      response(201, description: 'successfully created') do
        it 'uses the params we passed in' do
          json = JSON.parse(response.body)
          # binding.pry
          item = json['data']
          expect(item['token']).to be_truthy
        end
        capture_example
      end
    end
  end
end
