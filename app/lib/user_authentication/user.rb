# frozen_string_literal: true

module UserAuthentication
  class User
    TOKEN_KEY = :user_id

    def initialize(klass: nil, user: nil)
      @klass = klass
      @user = user
    end

    def find(http_auth_token)
      @http_auth_token = http_auth_token

      return if @http_auth_token.blank? || token_payload.blank?

      user_id = token_payload[TOKEN_KEY.to_s]
      @klass.where(id: user_id).first

      # current_user.authentications.find token_payload[:auth_id]
    end

    def new_token
      payload = { TOKEN_KEY => @user.id.to_s }
      UserAuthentication::Token.issue(payload)
    end

    private

    # Decode the authorization header token and return the payload
    def token_payload
      @token_payload ||= UserAuthentication::Token.decode(@http_auth_token)
    end
  end
end
