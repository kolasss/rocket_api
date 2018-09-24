# frozen_string_literal: true

module Shops
  module Products
    module Concerns
      module BaseProduct
        extend ActiveSupport::Concern
        include Mongoid::Document

        included do
          field :title, type: String
          # field :image, type: String
          field :description, type: String
          field :price, type: BigDecimal
          field :weight, type: String
        end
      end
    end
  end
end
