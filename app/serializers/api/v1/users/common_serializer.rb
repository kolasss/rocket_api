# frozen_string_literal: true

module Api
  module V1
    module Users
      class CommonSerializer < Api::V1::ObjectSerializer
        USER_TYPES = {
          'Users::Client' => 'client',
          'Users::Courier' => 'courier',
          'Users::Admin' => 'admin',
          'Users::Supervisor' => 'supervisor',
          'Users::ShopManager' => 'shop_manager'
        }.freeze

        json_schema do
          {
            id: String,
            name: String,
            phone: String,
            role: String
          }
        end

        def role
          USER_TYPES[object._type]
        end
      end
    end
  end
end
