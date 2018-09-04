# frozen_string_literal: true

module Api
  module V1
    class ObjectSerializer < Surrealist::Serializer
      private

      def id
        object._id.to_s
      end
    end
  end
end
