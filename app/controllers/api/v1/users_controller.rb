# frozen_string_literal: true

module Api
  module V1
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
            location: api_v1_user_path(@user)
          )
        else
          render_error
        end
      end

      def update
        set_user
        if @user.update(user_params)
          render json: json_success(serialize_user)
        else
          render_error
        end
      end

      def destroy
        set_user
        if @user.destroy
          head :no_content
        else
          render_error
        end
      end

      private

      def set_user
        @user = ::Users::User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :title,
          :description,
          category_ids: []
        )
      end

      def render_error
        json = json_error(
          code: 422,
          errors: @user.errors
        )
        render(
          json: json,
          status: :unprocessable_entity
        )
      end

      def serialize_user
        Api::V1::Users::Serializer.new(@user).build_schema
      end
    end
  end
end
