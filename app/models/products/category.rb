# frozen_string_literal: true

module Products
  class Category
    include Mongoid::Document
    field :title, type: String

    embedded_in(
      :shop, class_name: 'Shops::Shop', inverse_of: :products_categories
    )
    embeds_many(
      :products, class_name: 'Products::Product', inverse_of: :category
    )
  end
end
