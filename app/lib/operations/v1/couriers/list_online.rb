# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      class ListOnline < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        def call
          ids = online_ids
          return Success([]) if ids.empty?

          geopositions = online_geopositions(ids)
          couriers = online_couriers(ids)
          couriers = add_geopositions(couriers, geopositions)
          Success(couriers)
        end

        private

        def online_ids
          status_service.actual
        end

        def online_geopositions(ids)
          geo_hash = {}
          positions = location_service.positions(ids)
          ids.each.with_index do |id, index|
            geo_hash[id] = format_geoposition(positions[index])
          end
          geo_hash
        end

        def format_geoposition(redis_position)
          return nil if redis_position.blank?

          { lat: redis_position[1], lon: redis_position[0] }
        end

        def online_couriers(ids)
          ::Users::Courier.where(status: 'online').in(id: ids)
        end

        def add_geopositions(couriers, geopositions)
          couriers.map do |courier|
            courier.geoposition = geopositions[courier.id.to_s]
            courier
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
