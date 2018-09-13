# frozen_string_literal: true

module UserAuthentication
  class Token
    ALGORITHM = 'HS256'
    SECRET = Rails.application.credentials.secret_key_base

    def self.issue(payload)
      JWT.encode(
        payload,
        SECRET,
        ALGORITHM
      )
    end

    def self.decode(token)
      JWT.decode(
        token,
        SECRET,
        true,
        algorithm: ALGORITHM
      ).first
    rescue JWT::DecodeError
      nil
    end
  end
end
