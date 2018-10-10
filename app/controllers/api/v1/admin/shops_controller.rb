# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ShopsController < ApplicationController
        def index
          @shops = ::Shops::Shop.all.without(:products_categories)

          shops_json = Api::V1::Shops::CompactSerializer.new(
            @shops
          ).build_schema
          # json = {
          #   response: {
          #     data: shops_json
          #   }
          # }
          # render json: json
          render json: json_success(items: shops_json)
        end

        def show
          set_shop
          render json: json_success(serialize_shop)
        end

        def create
          @shop = ::Shops::Shop.new(shop_params)

          if @shop.save
            render(
              json: json_success(serialize_shop),
              status: :created,
              location: api_v1_admin_shop_path(@shop)
            )
          else
            # render json: @shop.errors, status: :unprocessable_entity
            render_shop_error
          end
        end

        def update
          set_shop
          if @shop.update(shop_params)
            render json: json_success(serialize_shop)
          else
            # render json: @shop.errors, status: :unprocessable_entity
            render_shop_error
          end
        end

        def destroy
          set_shop
          if @shop.destroy
            head :no_content
          else
            render_shop_error
          end
        end

        private

        def set_shop
          @shop = ::Shops::Shop.find(params[:id])
        end

        def shop_params
          params.require(:shop).permit(
            :title,
            :description,
            { category_ids: [] },
            { district_ids: [] },
            :minimum_order_price
          )
        end

        def render_shop_error
          render_error(
            status: :unprocessable_entity,
            errors: @shop.errors.as_json
          )
        end

        def serialize_shop
          Api::V1::Shops::Serializer.new(@shop).build_schema
        end
      end
    end
  end
end
