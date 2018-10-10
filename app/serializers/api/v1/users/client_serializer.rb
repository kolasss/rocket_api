# frozen_string_literal: true

module Api
  module V1
    module Users
      class ClientSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            name: String,
            phone: String,
            role: String,
            district_id: String
          }
        end

        def role
          'client'
        end

        def district_id
          object.district_id&.to_s
        end
      end
    end
  end
end
