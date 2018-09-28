# frozen_string_literal: true

module Users
  class Client < Users::User
    field :code_hash, type: String

    has_many(
      :orders,
      class_name: 'Orders::Order',
      inverse_of: :client,
      dependent: :restrict_with_error
    )
  end
end
