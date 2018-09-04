# frozen_string_literal: true

module Api
  module V1
    module ShopsCategories
      class CompactSerializer < Api::V1::ObjectSerializer
        json_schema do
          {
            id: String,
            title: String
          }
        end
      end
    end
  end
end
