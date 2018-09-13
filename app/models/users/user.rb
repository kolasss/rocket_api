# frozen_string_literal: true

module Users
  class User
    include Mongoid::Document
    field :name, type: String
    field :phone, type: String
    # field :code_hash, type: String
  end
end
