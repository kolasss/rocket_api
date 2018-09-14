# frozen_string_literal: true

module Api
  module V1
    module Users
      class AuthenticationController < ApplicationController
        skip_before_action :authenticate

        def create
          # TODO: move to operation
          @user = ::Users::User.where(phone: user_params[:phone]).first
          # @user = ::Users::User.find_by(phone: user_params[:phone])

          # TODO: check code_hash with hash of params code
          if @user&.code_hash.present? && @user.code_hash == user_params[:code]
            token = UserAuthentication::User.new(user: @user).new_token
            render(
              json: json_success(token: token),
              status: :created
            )
          else
            render_not_authorized
          end
        end

        # def destroy
        #   head :no_content
        # end

        private

        def user_params
          params.require(:user).permit(
            :code,
            :phone
          )
        end
      end
    end
  end
end
