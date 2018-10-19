# frozen_string_literal: true

module Shops
  module Products
    class Product
      include Mongoid::Document
      include ImageUploader[:image]

      field :title, type: String
      field :image_data, type: Hash
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
