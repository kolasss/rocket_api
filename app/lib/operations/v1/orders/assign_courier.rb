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
          yield update_order(order, courier)
          yield update_courier(order, courier)
          yield unready_courier(courier)
          Success(order)
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

        def find_courier(courier_id)
          courier = ::Users::Courier.where(id: courier_id).first
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
          if courier.active_order?
            Failure(:courier_is_busy)
          elsif order.courier_assignments.where(courier_id: courier.id).any?
            Failure(:already_assigned_to_this_courier)
          else
            Success(true)
          end
        end

        def update_order(order, courier)
          order.courier = courier
          build_assignment(order, courier)

          # TODO: transactions only allowed on replica sets
          # success = order.with_session do |session|
          #   session.start_transaction
          #   order.save
          #   courier.save
          #   session.commit_transaction
          # end
          if order.save
            Success(order)
          else
            Failure(order: order.errors.as_json)
          end
        end

        def build_assignment(order, courier)
          order.courier_assignments.new(
            status: 'proposed',
            courier_id: courier.id,
            proposed_at: Time.current
          )
        end

        def update_courier(order, courier)
          courier.active_order = order

          if courier.save
            Success(courier)
          else
            Failure(courier: courier.errors.as_json)
          end
        end

        def unready_courier(courier)
          operation = Operations::V1::Couriers::Unready.new
          operation.call(courier)
        end
      end
    end
  end
end
