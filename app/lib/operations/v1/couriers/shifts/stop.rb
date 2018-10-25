# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      module Shifts
        class Stop < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(courier)
            yield check_courier(courier)
            yield complete_shift(courier)
            yield update_status(courier)
            update_redis(courier.id.to_s)
          end

          private

          def check_courier(courier)
            if !courier.is_a?(::Users::Courier)
              Failure(:user_is_not_courier)
            elsif courier.status != 'online'
              Failure(invalid_status: courier.status)
            else
              Success(true)
            end
          end

          def complete_shift(courier)
            shift = courier.shifts.current
            return Failure(:shift_not_found) if shift.blank?

            shift.ended_at = Time.current
            if shift.save
              Success(true)
            else
              Failure(shift: shift.errors.as_json)
            end
          end

          def update_status(courier)
            courier.status = 'offline'
            if courier.save
              Success(true)
            else
              Failure(courier: courier.errors.as_json)
            end
          end

          def update_redis(id)
            service = Services::CourierStatusManager.new
            service.remove(id)
            Success(true)
          end
        end
      end
    end
  end
end
