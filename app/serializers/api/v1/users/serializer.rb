# frozen_string_literal: true

module Api
  module V1
    module Users
      class Serializer
        def initialize(object)
          @object = object
        end

        def build_schema
          if Surrealist::Helper.collection?(@object)
            serialize_collection(@object)
          else
            serialize(@object)
          end
        end

        private

        def serialize_collection(collection)
          collection.map { |object| serialize(object) }
        end

        def serialize(object)
          case object.class
          when ::Users::ShopManager
            ShopManagerSerializer.new(object).build_schema
          when ::Users::Client
            ClientSerializer.new(object).build_schema
          else
            CommonSerializer.new(object).build_schema
          end
        end
      end
    end
  end
end
