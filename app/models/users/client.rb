# frozen_string_literal: true

module Users
  class Client < Users::User
    field :code_hash, type: String

    embeds_many :addresses, as: :addressable, class_name: 'Locations::Address'
    embeds_one :token, as: :messageable, class_name: 'Users::Messages::Token'
    has_many(
      :orders,
      class_name: 'Orders::Order',
      inverse_of: :client,
      dependent: :restrict_with_error
    )
    belongs_to(
      :active_order,
      class_name: 'Orders::Order',
      inverse_of: nil,
      dependent: :restrict_with_error,
      optional: true
    )
  end
end
