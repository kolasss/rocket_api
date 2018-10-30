# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Common
        class Authenticate < ::Operations::V1::Users::Authenticate
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              required(:phone).filled(:str?)
              required(:password).filled(:str?)
              required(:role).filled(:str?)
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            klass = yield detect_class(payload[:user][:role])
            user = yield find_user(payload[:user][:phone], klass)
            yield check_password(user, payload[:user][:password])
            token = get_token(user)
            Success(
              user: user,
              token: token
            )
          end

          private

          def detect_class(role)
            klass = Services::UserClassDetector.new.common_class(role)
            klass ? Success(klass) : Failure(:invalid_role)
          end

          def check_password(user, password)
            if user.password_hash.present? &&
               user.password_hash == encrypt_code(password)
              Success(true)
            else
              Failure(:invalid_password)
            end
          end
        end
      end
    end
  end
end
