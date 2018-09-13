# frozen_string_literal: true

module Api
  module V1
    module Users
      class AuthenticationController < ApplicationController
        skip_before_action :authenticate

        def create
          @user = ::Users::User.find_by(phone: user_params[:phone])

          if @user.code_hash == user_params[:code]
            payload = UserAuthentication::User.payload(@user)
            jwt = UserAuthentication::Token.issue(payload)
            render json: { token: jwt }
          else
            not_authorized
          end
        end

        # def destroy
        #   head :ok
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
