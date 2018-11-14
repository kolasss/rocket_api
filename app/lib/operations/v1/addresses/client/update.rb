# frozen_string_literal: true

module Operations
  module V1
    module Addresses
      module Client
        class Update < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:address).schema do
              optional(:title).maybe(:str?)
              optional(:street).filled(:str?)
              optional(:building).filled(:str?)
              optional(:apartment).maybe(:str?)
              optional(:entrance).maybe(:str?)
              optional(:floor).maybe(:str?)
              optional(:intercom).maybe(:str?)
              optional(:note).maybe(:str?)
              optional(:location).schema do
                required(:lat).filled(:float?)
                required(:lon).filled(:float?)
              end
            end
          end

          def call(params:, address:)
            payload = yield VALIDATOR.call(params).to_monad
            update_address(address, payload[:address])
          end

          private

          def update_address(address, address_params)
            address.assign_attributes(address_params)
            if address.save
              Success(address)
            else
              Failure(address: address.errors.as_json)
            end
          end
        end
      end
    end
  end
end
