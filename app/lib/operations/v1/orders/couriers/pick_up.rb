# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module Couriers
        class PickUp < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(courier)
            order = yield find_order(courier)
            yield check_order(order, courier)
            update_order(order)
          end

          private

          def find_order(courier)
            order = courier.active_order
            if order.present?
              Success(order)
            else
              Failure(:order_not_found)
            end
          end

          def check_order(order, courier)
            if order.status != 'courier_at_shop'
              Failure(:invalid_order_status)
            elsif order.courier != courier
              Failure(:not_current_assignment)
            else
              Success(true)
            end
          end

          def update_order(order)
            order.status = 'on_delivery'
            if order.save
              Success(order)
            else
              Failure(order: order.errors.as_json)
            end
          end
        end
      end
    end
  end
end
