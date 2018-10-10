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
    has_many(
      :clients,
      class_name: 'Users::Client',
      inverse_of: :district,
      dependent: :restrict_with_error
    )
  end
end
