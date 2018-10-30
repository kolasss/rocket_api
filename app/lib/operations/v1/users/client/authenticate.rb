# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Client
        class Authenticate < ::Operations::V1::Users::Authenticate
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              required(:phone).filled(:str?)
              required(:code).filled(:str?)
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            user = yield find_user(payload[:user][:phone], ::Users::Client)
            yield check_code(user, payload[:user][:code])
            token = get_token(user)
            Success(
              user: user,
              token: token
            )
          end

          private

          def check_code(user, code)
            if user.code_hash.present? && user.code_hash == encrypt_code(code)
              Success(true)
            else
              Failure(:wrong_code)
            end
          end
        end
      end
    end
  end
end
