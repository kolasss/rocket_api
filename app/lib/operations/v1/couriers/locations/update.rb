# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      module Locations
        class Update < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:lat).filled(:float?)
            required(:lon).filled(:float?)
          end

          def call(courier:, params:)
            payload = yield VALIDATOR.call(params).to_monad
            yield check_courier(courier)
            yield update_position(courier.id.to_s, payload)
            update_status(courier.id.to_s)
          end

          private

          def check_courier(courier)
            if !courier.is_a?(::Users::Courier)
              Failure(:user_is_not_courier)
            else
              Success(true)
            end
          end

          def update_position(id, params)
            service = Services::CourierGeopositionManager.new
            service.add(id: id, lat: params[:lat], lon: params[:lon])
            Success(true)
          end

          def update_status(id)
            service = Services::CourierStatusManager.new
            service.add(id)
            Success(true)
          end
        end
      end
    end
  end
end
