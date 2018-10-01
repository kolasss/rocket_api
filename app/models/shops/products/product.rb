# frozen_string_literal: true

module Shops
  module Products
    class Product
      include ::Shops::Products::Concerns::BaseProduct

      embedded_in(
        :category,
        class_name: 'Shops::Products::Category',
        inverse_of: :products
      )
    end
  end
end