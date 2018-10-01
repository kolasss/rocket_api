# frozen_string_literal: true

module Orders
  class CourierAssignment
    include Mongoid::Document
    field :status, type: String
    field :decline_reason, type: String
    field :courier_id, type: BSON::ObjectId

    embedded_in(
      :order, class_name: 'Orders::Order', inverse_of: :courier_assignments
    )

    STATUSES = %w[
      proposed
      accepted
      declined
    ].freeze

    validates :status, inclusion: { in: STATUSES }
  end
end
