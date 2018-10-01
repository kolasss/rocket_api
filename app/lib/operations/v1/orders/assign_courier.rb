# frozen_string_literal: true

module Operations
  module V1
    module Orders
      class AssignCourier < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        def call(id:, courier_id:)
          order = yield find_order(id)
          yield check_status(order)
          courier = yield find_courier(courier_id)
          yield validate_assignment(order, courier)
          assign_courier(order, courier)
        end

        private

        def find_order(id)
          order = ::Orders::Order.where(id: id).first
          if order.present?
            Success(order)
          else
            Failure(:order_not_found)
          end
        end

        def find_courier(id)
          courier = ::Users::Courier.where(id: id).first
          if courier.present?
            Success(courier)
          else
            Failure(:courier_not_found)
          end
        end

        def check_status(order)
          if order.status == 'requested'
            Success(true)
          else
            Failure(:invalid_order_status)
          end
        end

        def validate_assignment(order, courier)
          if order.courier_assignments.where(courier_id: courier.id).any?
            Failure(:already_assigned_to_courier)
          else
            Success(true)
          end
        end

        def assign_courier(order, courier)
          order.courier = courier
          build_assignment(order, courier)

          if order.save
            Success(order)
          else
            Failure(order.errors.as_json)
          end
        end

        def build_assignment(order, courier)
          order.courier_assignments.new(
            status: 'proposed',
            courier_id: courier.id
          )
        end
      end
    end
  end
end
