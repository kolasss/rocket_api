# frozen_string_literal: true

module Operations
  module Users
    class AuthenticateUser < ::Operations::Base
      include Dry::Monads::Do.for(:call)

      VALIDATOR = Dry::Validation.Schema do
        required(:user).schema do
          required(:phone).filled(:str?)
          required(:code).filled(:str?)
        end
      end

      def call(params)
        payload = yield VALIDATOR.call(params).to_monad
        user = yield find_user(payload[:user][:phone])
        yield check_code(user, payload[:user][:code])
        get_token(user)
      end

      private

      def find_user(phone)
        user = ::Users::User.where(phone: phone).first
        if user.present?
          Success(user)
        else
          Failure(:not_found)
        end
      end

      def check_code(user, code)
        if user&.code_hash.present? && user.code_hash == encrypt_code(code)
          Success(true)
        else
          Failure(:wrong_code)
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
