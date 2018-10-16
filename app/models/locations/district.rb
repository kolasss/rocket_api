# frozen_string_literal: true

module Locations
  class District
    include Mongoid::Document
    field :title, type: String

    has_and_belongs_to_many(
      :shops,
      class_name: 'Shops::Shop',
      inverse_of: :districts,
      dependent: :restrict_with_error
    )
  end
end
