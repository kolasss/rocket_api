# frozen_string_literal: true

module Users
  class User
    include Mongoid::Document
    field :name, type: String
    field :phone, type: String

    # def client?
    #   role == 'client'
    # end

    # def courier?
    #   role == 'courier'
    # end
  end
end
