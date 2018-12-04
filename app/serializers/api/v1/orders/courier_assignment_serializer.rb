# frozen_string_literal: true

module Api
  module V1
    module Orders
      class CourierAssignmentSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            status: String,
            decline_reason: String,
            courier_id: String
          }
        end

        def courier_id
          object.courier_id&.to_s
        end
      end
    end
  end
end
