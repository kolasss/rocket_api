# frozen_string_literal: true

module Shops
  class Shop
    include Mongoid::Document
    field :title, type: String
    # field :image, type: String
    field :description, type: String
    # field :coordinates, type: String

    # validates :description, presence: true

    has_and_belongs_to_many(
      :categories, class_name: 'Shops::Category', inverse_of: :shops
    )
    embeds_many(
      :products_categories,
      class_name: 'Shops::Products::Category',
      inverse_of: :shop
    )
    has_many(
      :orders,
      class_name: 'Orders::Order',
      inverse_of: :shop,
      dependent: :restrict_with_error
    )
  end
end
