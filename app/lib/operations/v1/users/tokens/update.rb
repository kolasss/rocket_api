# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Tokens
        class Update < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          PLATFORMS = %w[android ios].freeze

          VALIDATOR = Dry::Validation.Schema do
            required(:token).schema do
              required(:key).filled(:str?)
              required(:platform).value(
                :filled?, :str?, included_in?: PLATFORMS
              )
            end
          end

          def call(params:, user:)
            payload = yield VALIDATOR.call(params).to_monad
            token = find_token(user)
            yield update_token(token, payload[:token])
            Success(user)
          end

          private

          def find_token(user)
            user.token || user.build_token
          end

          def update_token(token, params)
            token.assign_attributes(params)
            if token.save
              Success(true)
            else
              Failure(token: token.errors.as_json)
            end
          end
        end
      end
    end
  end
end
