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
            yield count_delivery(courier)
            yield update_client(order)
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
            courier.status = 'online'
            if courier.save
              Success(true)
            else
              Failure(courier: courier.errors.as_json)
            end
          end

          def count_delivery(courier)
            shift = courier.shifts.current
            return Failure(:shift_not_found) if shift.blank?

            if shift.inc(delivered: 1)
              Success(true)
            else
              Failure(shift: shift.errors.as_json)
            end
          end

          def update_client(order)
            client = order.client
            client.active_order = nil

            if client.save
              Success(client)
            else
              Failure(client: client.errors.as_json)
            end
          end
        end
      end
    end
  end
end
