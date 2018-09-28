# frozen_string_literal: true

module Users
  class ShopManager < Users::User
    field :password_hash, type: String

    belongs_to(
      :shop,
      class_name: 'Shops::Shop',
      inverse_of: :manager,
      optional: true
    )
  end
end
