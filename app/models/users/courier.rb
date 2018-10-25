# frozen_string_literal: true

module Users
  class Courier < Users::User
    field :password_hash, type: String
    field :status, type: String

    STATUSES = %w[
      offline
      online
      on_delivery
    ].freeze

    validates :status, inclusion: { in: STATUSES }

    has_many(
      :orders,
      class_name: 'Orders::Order',
      inverse_of: :courier,
      dependent: :restrict_with_error
    )
    belongs_to(
      :active_order,
      class_name: 'Orders::Order',
      inverse_of: nil,
      dependent: :restrict_with_error,
      optional: true
    )
    embeds_many(
      :shifts,
      class_name: 'Users::Couriers::Shift',
      inverse_of: :courier
    )
  end
end
