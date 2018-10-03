# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      class Ready < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        def call(courier)
          yield check_courier(courier)
          make_ready(courier.id.to_s)
        end

        private

        def check_courier(courier)
          if !courier.is_a?(::Users::Courier)
            Failure(:user_is_not_courier)
          elsif courier.active_order?
            Failure(:courier_has_active_order)
          else
            Success(true)
          end
        end

        def make_ready(id)
          service = Services::CourierStatusManager.new
          service.add(id)
          Success(true)
        end
      end
    end
  end
end
