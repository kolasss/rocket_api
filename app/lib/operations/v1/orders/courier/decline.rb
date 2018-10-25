# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module Courier
        class Decline < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:reason).filled(:str?)
          end

          def call(courier:, params:)
            payload = yield VALIDATOR.call(params).to_monad
            order = yield find_order(courier)
            yield check_order(order, courier)
            assignment = yield find_assignment(order, courier.id)
            yield validate_assignment(assignment)
            yield update_assignment(assignment, payload[:reason])
            yield update_courier(courier)
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
            if order.status != 'requested'
              Failure(:invalid_order_status)
            elsif order.courier != courier
              Failure(:not_current_assignment)
            else
              Success(true)
            end
          end

          def find_assignment(order, courier_id)
            assignment = order.courier_assignments
                              .where(courier_id: courier_id)
                              .first
            if assignment.present?
              Success(assignment)
            else
              Failure(:assignment_not_found)
            end
          end

          def validate_assignment(assignment)
            if assignment.status == 'proposed'
              Success(true)
            else
              Failure(:invalid_assignment_status)
            end
          end

          def update_assignment(assignment, reason)
            assignment.status = 'declined'
            assignment.decline_reason = reason
            if assignment.save
              Success(true)
            else
              Failure(assignment: assignment.errors.as_json)
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

          def update_order(order)
            order.courier = nil
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
