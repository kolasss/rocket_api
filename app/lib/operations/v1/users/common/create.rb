# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Common
        class Create < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              optional(:name).filled(:str?)
              # required(:phone).filled(:str?, format?: GITHUB_LINK)
              required(:phone).filled(:str?)
              required(:password).filled(:str?)
              required(:role).filled(:str?)
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            klass = yield detect_class(payload[:user][:role])
            create(payload[:user], klass)
          end

          private

          def detect_class(role)
            klass = Services::UserClassDetector.new.common_class(role)
            klass ? Success(klass) : Failure(:invalid_role)
          end

          def create(params, klass)
            user = klass.new(
              phone: params[:phone],
              name: params[:name]
            )
            user.password_hash = encrypt_code(params[:password])

            if user.save
              Success(user)
            else
              Failure(user: user.errors.as_json)
            end
          end

          def encrypt_code(code)
            ::UserAuthentication::Code.hash(code)
          end
        end
      end
    end
  end
end
