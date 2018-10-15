# frozen_string_literal: true

module Orders
  class Product
    include Mongoid::Document

    field :title, type: String
    # field :image, type: String
    field :description, type: String
    field :price, type: BigDecimal
    field :weight, type: String
    field :quantity, type: Integer
    field :shop_product_id, type: BSON::ObjectId

    embedded_in(
      :order, class_name: 'Orders::Order', inverse_of: :products
    )
  end
end
