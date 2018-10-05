# frozen_string_literal: true

module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        def index
          @users = ::Users::User.all

          users_json = Api::V1::Users::Serializer.new(
            @users
          ).build_schema
          render json: json_success(items: users_json)
        end

        def show
          set_user
          render json: json_success(serialize_user)
        end

        def create
          @user = ::Users::User.new(user_params)

          if @user.save
            render(
              json: json_success(serialize_user),
              status: :created,
              location: api_v1_admin_user_path(@user)
            )
          else
            render_user_error
          end
        end

        def update
          set_user
          if @user.update(user_params)
            render json: json_success(serialize_user)
          else
            render_user_error
          end
        end

        def destroy
          set_user
          if @user.destroy
            head :no_content
          else
            render_user_error
          end
        end

        private

        def set_user
          @user = ::Users::User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(
            :name,
            :phone
          )
        end

        def render_user_error
          render_error(
            status: :unprocessable_entity,
            errors: @user.errors.as_json
          )
        end

        def serialize_user
          Api::V1::Users::Serializer.new(@user).build_schema
        end
      end
    end
  end
end
