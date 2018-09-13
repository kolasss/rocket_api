# frozen_string_literal: true

module Api
  module V1
    module Users
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            name: String,
            phone: String
          }
        end
      end
    end
  end
end
