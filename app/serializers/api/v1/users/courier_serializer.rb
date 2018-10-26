# frozen_string_literal: true

module Api
  module V1
    module Users
      class CourierSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            name: String,
            phone: String,
            role: String,
            status: String,
            active_order_id: String,
            geoposition: Hash
          }
        end

        def role
          'courier'
        end

        def active_order_id
          object.active_order_id.to_s
        end
      end
    end
  end
end
