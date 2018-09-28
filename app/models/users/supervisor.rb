# frozen_string_literal: true

module Users
  class Supervisor < Users::User
    field :password_hash, type: String
  end
end
