# frozen_string_literal: true

module Orders
  class Product
    include ::Shops::Products::Concerns::BaseProduct
    field :quantity, type: Integer
    field :shop_product_id, type: BSON::ObjectId

    embedded_in(
      :order, class_name: 'Orders::Order', inverse_of: :products
    )

    # TODO: move to operation
    validates :shop_product_id, uniqueness: { scope: :order }
  end
end
