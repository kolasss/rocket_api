# frozen_string_literal: true

module Shops
  class Shop
    include Mongoid::Document
    field :title, type: String
    # field :image, type: String
    field :description, type: String
    # field :coordinates, type: String

    has_and_belongs_to_many(
      :categories, class_name: 'Shops::Category', inverse_of: :shops
    )
    embeds_many(
      :products_categories, class_name: 'Products::Category', inverse_of: :shop
    )
  end
end
