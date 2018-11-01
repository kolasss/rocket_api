# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Common
        class Update < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              required(:name).filled(:str?)
            end
          end

          def call(params:, user:)
            payload = yield VALIDATOR.call(params).to_monad
            update_user(user, payload[:user])
          end

          private

          def update_user(user, params)
            user.assign_attributes(params)
            if user.save
              Success(user)
            else
              Failure(user: user.errors.as_json)
            end
          end
        end
      end
    end
  end
end
