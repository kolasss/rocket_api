# frozen_string_literal: true

module UserAuthentication
  class User
    TOKEN_KEY = :user_id

    def initialize(klass)
      @klass = klass
    end

    def find(payload)
      return nil if payload.blank?

      @klass.find(payload[TOKEN_KEY.to_s])

      # current_user.authentications.find decoded_auth_token[:auth_id]
    end

    def self.payload(user)
      { TOKEN_KEY => user.id.to_s }
    end
  end
end
