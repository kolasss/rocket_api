# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'shops', type: :request, tags: ['admin shops'] do
  let(:user) { create(:admin) }
  let(:token) { UserAuthentication::User.new(user: user).new_token }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/admin/shops' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    get summary: 'list items' do
      let!(:shop) { create(:shop) }

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
          it 'shop' do
            expect(items[0]['title']).to eq shop.title
          end
        end

        capture_example
      end
    end

    description = 'image and logo have type file'
    post summary: 'create', description: description do
      let(:category) { create(:shop_category) }
      let(:district) { create(:district) }
      let(:item_attributes) { attributes_for(:shop) }

      produces 'application/json'
      consumes 'application/json', 'multipart/form-data'

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          shop: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              category_ids: {
                type: :array,
                items: { type: :string }
              },
              minimum_order_price: { type: :number },
              district_ids: {
                type: :array,
                items: { type: :string }
              },
              image: { type: :string },
              logo: { type: :string }
            }
          }
        }
      }
      # parameter 'shop[image]', in: :formData, type: :file
      let(:body) do
        { shop: item_attributes.merge(
          category_ids: [category.id.to_s],
          district_ids: [district.id.to_s]
        ) }
      end

      response(201, description: 'successfully created') do
        context 'with params to create' do
          let(:json) { JSON.parse(response.body) }
          let(:item) { json['data'] }

          it 'title' do
            expect(item['title']).to eq item_attributes[:title]
          end
          it 'categories' do
            expect(item['categories'][0]['title']).to eq category.title
          end
          it 'districts' do
            expect(item['districts'][0]['title']).to eq district.title
          end
        end

        capture_example
      end
    end
  end

  path '/api/v1/admin/shops/{shop_id}' do
    parameter(
      :Authorization,
      in: :header,
      type: :string,
      required: true,
      description: 'Bearer token'
    )

    parameter :shop_id, in: :path, type: :string, required: true
    let(:shop) { create(:shop) }
    let(:shop_id) { shop.id.to_s }

    get summary: 'fetch an item' do
      produces 'application/json'

      response(200, description: 'success') do
        capture_example
      end
    end

    description = 'image and logo have type file'
    put summary: 'update an item', description: description do
      produces 'application/json'
      consumes 'application/json', 'multipart/form-data'

      let(:new_title) { 'new title' }

      parameter :body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          shop: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              category_ids: {
                type: :array,
                items: { type: :string }
              },
              minimum_order_price: { type: :number },
              district_ids: {
                type: :array,
                items: { type: :string }
              },
              image: { type: :string },
              logo: { type: :string }
            }
          }
        }
      }
      let(:body) do
        { shop: { title: new_title } }
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
