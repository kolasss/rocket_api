# frozen_string_literal: true

module Orders
  class Order
    include Mongoid::Document
    # field :address, type: String
    # field :district, type: String
    # field :address, type: String
    field :status, type: String
    # field :courier_status, type: String
    # field :shop_status, type: String
    field :price_total, type: BigDecimal

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

    STATUSES = %w[
      new
      requested
      accepted
      at_shop
      on_delivery
      at_client
      delivered
      canceled
    ].freeze

    validates :status, inclusion: { in: STATUSES }
  end
end
