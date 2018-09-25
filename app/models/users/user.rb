# frozen_string_literal: true

module Users
  class User
    include Mongoid::Document
    field :name, type: String
    field :phone, type: String
    field :code_hash, type: String
    field :role, type: String

    # for client
    has_many(
      :client_orders,
      class_name: 'Orders::Order',
      inverse_of: :client,
      dependent: :restrict_with_error
    )

    # for courier
    has_many(
      :courier_orders,
      class_name: 'Orders::Order',
      inverse_of: :courier,
      dependent: :restrict_with_error
    )

    # for shop_manager
    belongs_to(
      :shop,
      class_name: 'Shops::Shop',
      inverse_of: :manager,
      optional: true
    )

    ROLES = %w[
      client
      courier
      admin
      supervisor
      shop_manager
    ].freeze

    validates :role, inclusion: { in: ROLES }

    # def client?
    #   role == 'client'
    # end

    # def courier?
    #   role == 'courier'
    # end
  end
end
