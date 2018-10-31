# frozen_string_literal: true

module Orders
  class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    # field :address, type: String
    # field :district, type: String
    field :status, type: String
    field :price_total, type: BigDecimal
    field :cancel_reason, type: String

    belongs_to(
      :client,
      class_name: 'Users::Client',
      inverse_of: :orders
    )
    belongs_to(
      :courier,
      class_name: 'Users::Courier',
      inverse_of: :orders,
      optional: true
    )
    belongs_to :shop, class_name: 'Shops::Shop', inverse_of: :orders
    embeds_many(
      :products, class_name: 'Orders::Product', inverse_of: :order
    )
    embeds_many(
      :courier_assignments,
      class_name: 'Orders::CourierAssignment',
      inverse_of: :order
    )
    embeds_one(
      :shop_response,
      class_name: 'Orders::ShopResponse',
      inverse_of: :order
    )
    embeds_one :address, as: :addressable, class_name: 'Locations::Address'

    STATUSES = %w[
      new
      requested
      accepted
      courier_at_shop
      on_delivery
      delivered
      canceled_supervisor
      canceled_shop
      canceled_client
    ].freeze

    validates :status, inclusion: { in: STATUSES }
  end
end
