# frozen_string_literal: true

module Api
  module V1
    class ObjectSerializer < Surrealist::Serializer
      private

      def id
        object._id.to_s
      end

      def image_json(image)
        return if image.blank?

        image.map { |version, file| { version => file.url } }
      end
    end
  end
end
