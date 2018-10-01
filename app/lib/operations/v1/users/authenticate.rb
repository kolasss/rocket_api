# frozen_string_literal: true

module Operations
  module V1
    module Users
      class Authenticate < ::Operations::V1::Base
        private

        def find_user(phone, klass)
          user = klass.where(phone: phone).first
          if user.present?
            Success(user)
          else
            Failure(:not_found)
          end
        end

        def get_token(user)
          Success(::UserAuthentication::User.new(user: user).new_token)
        end

        def encrypt_code(code)
          ::UserAuthentication::Code.hash(code)
        end
      end
    end
  end
end
