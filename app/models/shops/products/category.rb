# frozen_string_literal: true

module Shops
  module Products
    class Category
      include Mongoid::Document
      field :title, type: String

      embedded_in(
        :shop, class_name: 'Shops::Shop', inverse_of: :products_categories
      )
      embeds_many(
        :products, class_name: 'Shops::Products::Product', inverse_of: :category
      )

      # validates :title, presence: true
    end
  end
end
