# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops categories', type: :request,
                                   tags: ['client shops_categories'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/shops_categories' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:category) { create(:shop_category) }

      produces 'application/json'

      response(200, description: 'successful') do
        it 'contains array of categories' do
          json = JSON.parse(response.body)
          items = json['data']['items']
          expect(items).to be_an_instance_of(Array)
          expect(items.size).to eq 1
          expect(items[0]['title']).to eq category.title
        end
        capture_example
      end
    end
  end
end
