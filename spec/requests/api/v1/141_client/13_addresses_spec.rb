# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'addresses', type: :request,
                            tags: ['client addresses'] do
  let(:user) { create(:client) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/client/addresses' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:address) { create(:address, addressable: user) }

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
          it 'address' do
            expect(items[0]['title']).to eq address.title
          end
        end

        capture_example
      end
    end

    post summary: 'create' do
      let(:item_attributes) { attributes_for(:address) }
      let(:precision) { 5 }

      produces 'application/json'
      consumes 'application/json'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          address: {
            type: :object,
            properties: {
              title: { type: :string },
              street: { type: :string },
              building: { type: :string },
              apartment: { type: :string },
              entrance: { type: :string },
              floor: { type: :string },
              intercom: { type: :string },
              note: { type: :string },
              location: {
                type: :object,
                properties: {
                  lat: { type: :number },
                  lon: { type: :number }
                }
              }
            }
          }
        }
      }
      let(:body) do
        { address: item_attributes }
      end

      response(201, description: 'successfully created') do
        context 'with params to create' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'title' do
            expect(item['title']).to eq item_attributes[:title]
          end
          it 'location lat' do
            expect(item['location']['lat']).to(
              eq item_attributes[:location][:lat].round(precision)
            )
          end
          it 'location lon' do
            expect(item['location']['lon']).to(
              eq item_attributes[:location][:lon].round(precision)
            )
          end
        end

        capture_example
      end
    end
  end

  path '/api/v1/client/addresses/{address_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :address_id, in: :path, type: :string, required: true
    let(:address) { create(:address, addressable: user) }
    let(:address_id) { address.id.to_s }

    put summary: 'update an item' do
      produces 'application/json'
      consumes 'application/json'

      let(:new_title) { 'new title' }
      let(:new_lat) { 123.04538 }
      let(:new_lon) { -45.34566 }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          address: {
            type: :object,
            properties: {
              title: { type: :string },
              street: { type: :string },
              building: { type: :string },
              apartment: { type: :string },
              entrance: { type: :string },
              floor: { type: :string },
              intercom: { type: :string },
              note: { type: :string },
              location: {
                type: :object,
                properties: {
                  lat: { type: :number },
                  lon: { type: :number }
                }
              }
            }
          }
        }
      }
      let(:body) do
        {
          address: {
            title: new_title,
            note: '',
            location: {
              lat: new_lat,
              lon: new_lon
            }
          }
        }
      end

      response 200, description: 'success' do
        context 'with params to update' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'title' do
            expect(item['title']).to eq new_title
          end
          it 'location lat' do
            expect(item['location']['lat']).to eq new_lat
          end
          it 'location lon' do
            expect(item['location']['lon']).to eq new_lon
          end
        end

        capture_example
      end
    end

    delete summary: 'delete an item' do
      response 204, description: 'success'
    end
  end
end
