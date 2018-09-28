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
            role: String
          }
        end

        def role
          case object._type
          when 'Users::Client'      then 'client'
          when 'Users::Courier'     then 'courier'
          when 'Users::Admin'       then 'admin'
          when 'Users::Supervisor'  then 'supervisor'
          when 'Users::ShopManager' then 'shop_manager'
          end
        end
      end
    end
  end
end
