# frozen_string_literal: true

module Users
  class User
    include Mongoid::Document
    field :name, type: String
    field :phone, type: String
    field :code_hash, type: String
    field :role, type: String

    # embeds_one :client
    # embeds_one :courier
    has_many(
      :client_orders,
      class_name: 'Orders::Order',
      inverse_of: :client,
      dependent: :restrict_with_error
    )
    has_many(
      :courier_orders,
      class_name: 'Orders::Order',
      inverse_of: :courier,
      dependent: :restrict_with_error
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
