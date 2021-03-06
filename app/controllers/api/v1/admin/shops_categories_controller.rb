# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ShopsCategoriesController < ApplicationController
        def index
          @categories = ::Shops::Category.all

          categories_json = Api::V1::ShopsCategories::CompactSerializer.new(
            @categories
          ).build_schema

          render json: json_success(items: categories_json)
        end

        def create
          @category = ::Shops::Category.new(category_params)

          if @category.save
            render(
              json: json_success(serialize_category),
              status: :created,
              location: api_v1_admin_shops_categories_path
            )
          else
            render_category_error
          end
        end

        def update
          set_category
          if @category.update(category_params)
            render json: json_success(serialize_category)
          else
            render_category_error
          end
        end

        def destroy
          set_category
          if @category.destroy
            head :no_content
          else
            render_category_error
          end
        end

        private

        def set_category
          @category = ::Shops::Category.find(params[:id])
        end

        def category_params
          params.require(:category).permit(:title)
        end

        def render_category_error
          render_error(
            status: :unprocessable_entity,
            errors: @category.errors.as_json
          )
        end

        def serialize_category
          Api::V1::ShopsCategories::Serializer.new(
            @category
          ).build_schema
        end
      end
    end
  end
end
