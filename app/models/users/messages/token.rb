# frozen_string_literal: true

module Users
  module Messages
    class Token
      include Mongoid::Document

      field :key, type: String
      field :platform, type: String

      embedded_in(
        :messageable,
        polymorphic: true
      )
    end
  end
end
