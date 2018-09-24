# frozen_string_literal: true

module Api
  module V1
    module Users
      class Serializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            name: String,
            phone: String,
            role: String,
            # client: String,
            # courier: String
          }
        end

        # def client
        #   object.client.to_json
        # end

        # def courier
        #   object.client.to_json
        # end
      end
    end
  end
end
