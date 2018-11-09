# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Client
        class Register < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              # required(:phone).filled(:str?, format?: GITHUB_LINK)
              required(:phone).filled(:str?)
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            code = generate_code
            user = yield create(payload[:user][:phone], code)
            send_sms(user.phone, code)
            Success(user)
          end

          private

          def generate_code
            '1234' # TODO: generate random code
            # Random.rand(1000..9999)
          end

          def create(phone, code)
            user = ::Users::Client.find_or_initialize_by(phone: phone)
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

          def send_sms(phone, code)
            message = I18n.t('client.sms.code', code: code)
            SmsCodeWorker.perform_async(phone, message)
          end
        end
      end
    end
  end
end
