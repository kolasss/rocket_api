# frozen_string_literal: true

module Shops
  module Products
    class Product
      include Mongoid::Document

      field :title, type: String
      # field :image, type: String
      field :description, type: String
      field :price, type: BigDecimal
      field :weight, type: String

      embedded_in(
        :category,
        class_name: 'Shops::Products::Category',
        inverse_of: :products
      )
    end
  end
end
