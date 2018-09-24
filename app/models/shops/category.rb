# frozen_string_literal: true

module Shops
  class Category
    include Mongoid::Document
    field :title, type: String

    has_and_belongs_to_many(
      :shops,
      class_name: 'Shops::Shop',
      inverse_of: :categories,
      dependent: :restrict_with_error
    )
  end
end
