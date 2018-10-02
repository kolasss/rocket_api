# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'ready', type: :request, tags: ['courier ready'] do
  let(:user) { create(:courier) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/courier/ready' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    description = %(Сообщение серверу о то что курьер готов к заказу
Необходимо сообщать о готовности не реже чем раз в минуту.
Скорей всего в будущем координаты будут отсылаться сюда.)
    post summary: 'set status to ready', description: description do
      produces 'application/json'

      response(201, description: 'successful') do
        capture_example
      end
    end

    delete summary: 'set status to not ready' do
      produces 'application/json'

      response(204, description: 'successful') do
        capture_example
      end
    end
  end
end
