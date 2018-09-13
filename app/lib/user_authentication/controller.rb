# frozen_string_literal: true

module UserAuthentication
  module Controller
    private

    def logged_in?
      current_user.present?
    end

    def current_user
      @current_user = find_user_with_token unless defined?(@current_user)
      @current_user
    end

    def find_user_with_token
      return unless token_present?
      UserAuthentication::User.new(::Users::User)
                              .find(decoded_auth_token)
    end

    def token_present?
      http_auth_token.present? && decoded_auth_token.present?
    end

    # Raw Authorization Header token (json web token format)
    # JWT's are stored in the Authorization header using this format:
    # Bearer somerandomstring.encoded-payload.anotherrandomstring
    def http_auth_token
      @http_auth_token ||= request.headers['Authorization']&.split(' ')&.last
    end

    # Decode the authorization header token and return the payload
    def decoded_auth_token
      @decoded_auth_token ||= UserAuthentication::Token.decode(http_auth_token)
    end
  end
end
