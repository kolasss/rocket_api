# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module Courier
        class Deliver < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(courier)
            order = yield find_order(courier)
            yield check_order(order, courier)
            yield update_order(order)
            yield update_courier(courier)
            Success(order)
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
            if order.status != 'on_delivery'
              Failure(:invalid_order_status)
            elsif order.courier != courier
              Failure(:not_current_assignment)
            else
              Success(true)
            end
          end

          def update_order(order)
            order.status = 'delivered'
            if order.save
              Success(order)
            else
              Failure(order: order.errors.as_json)
            end
          end

          def update_courier(courier)
            courier.active_order = nil
            if courier.save
              Success(true)
            else
              Failure(courier: courier.errors.as_json)
            end
          end
        end
      end
    end
  end
end
