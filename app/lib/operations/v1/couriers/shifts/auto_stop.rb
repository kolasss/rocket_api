# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      module Shifts
        class AutoStop < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call
            ids = yield outdated_ids
            return Success(true) if ids.empty?

            yield clear_outdated_ids(ids)
            couriers = get_couriers(ids)
            couriers.each do |courier|
              yield complete_shift(courier)
              yield update_status(courier)
            end
            Success(true)
          end

          private

          def outdated_ids
            ids = status_service.outdated
            Success(ids)
          end

          def clear_outdated_ids(ids)
            status_service.clear_outdated
            location_service.remove(ids)
            Success(true)
          end

          def get_couriers(ids)
            ::Users::Courier.where(status: 'online').in(id: ids)
          end

          def complete_shift(courier)
            shift = courier.shifts.current
            return Failure(shift_not_found: courier.id.to_s) if shift.blank?

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

          def status_service
            @status_service ||= Services::CourierStatusManager.new
          end

          def location_service
            @location_service ||= Services::CourierGeopositionManager.new
          end
        end
      end
    end
  end
end
