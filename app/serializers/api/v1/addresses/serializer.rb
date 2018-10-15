# frozen_string_literal: true

module Api
  module V1
    module Addresses
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String,
            street: String,
            building: String,
            apartment: String,
            entrance: String,
            floor: String,
            intercom: String,
            note: String,
            location: Hash
          }
        end

        def location
          object.location.as_json
        end
      end
    end
  end
end
