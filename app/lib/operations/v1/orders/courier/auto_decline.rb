# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module Courier
        class AutoDecline < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(courier_id, order_id)
            courier = yield find_courier(courier_id)
            return Success(true) if courier.active_order_id.to_s != order_id

            decline_params = {
              reason: 'auto_decline'
            }
            decline_operation = Operations::V1::Orders::Courier::Decline.new
            decline_operation.call(
              params: decline_params,
              courier: courier
            )
            Success(true)
          end

          private

          def find_courier(courier_id)
            courier = ::Users::Courier.where(id: courier_id).first
            if courier.present?
              Success(courier)
            else
              Failure(:courier_not_found)
            end
          end
        end
      end
    end
  end
end
