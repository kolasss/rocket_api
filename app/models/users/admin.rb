# frozen_string_literal: true

module Users
  class Admin < Users::User
    field :password_hash, type: String
  end
end
