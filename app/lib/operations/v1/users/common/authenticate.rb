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
            user_class = yield set_class(payload[:user][:role])
            user = yield find_user(payload[:user][:phone], user_class)
            yield check_password(user, payload[:user][:password])
            get_token(user)
          end

          private

          def set_class(role)
            case role
            when 'supervisor' then Success(::Users::Supervisor)
            when 'courier' then Success(::Users::Courier)
            when 'admin' then Success(::Users::Admin)
            when 'shop_manager' then Success(::Users::ShopManager)
            else
              Failure(:invalid_role)
            end
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
