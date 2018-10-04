# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Client
        class Register < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              optional(:name).filled(:str?)
              # required(:phone).filled(:str?, format?: GITHUB_LINK)
              required(:phone).filled(:str?)
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            code = yield generate_code
            user = yield create(payload[:user], code)

            send_sms(user.phone, code)

            Success(user)
          end

          private

          def generate_code
            Success('1234') # TODO: generate random code
          end

          def create(params, code)
            user = ::Users::Client.new(params)
            user.code_hash = encrypt_code(code)

            if user.save
              Success(user)
            else
              Failure(user: user.errors.as_json)
            end
          end

          def encrypt_code(code)
            ::UserAuthentication::Code.hash(code)
          end

          def send_sms(_phone, code)
            # TODO: send code
            Rails.logger.info("User's code is #{code}")
          end
        end
      end
    end
  end
end
