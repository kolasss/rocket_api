# frozen_string_literal: true

module Users
  class Courier < Users::User
    field :password_hash, type: String

    has_many(
      :orders,
      class_name: 'Orders::Order',
      inverse_of: :courier,
      dependent: :restrict_with_error
    )
  end
end
