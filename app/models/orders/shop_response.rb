# frozen_string_literal: true

module Orders
  class ShopResponse
    include Mongoid::Document
    field :status, type: String

    embedded_in(
      :order, class_name: 'Orders::Order', inverse_of: :shop_response
    )

    STATUSES = %w[
      requested
      accepted
      canceled
    ].freeze

    validates :status, inclusion: { in: STATUSES }
  end
end
