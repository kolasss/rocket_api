# frozen_string_literal: true

module UserAuthentication
  module Controller
    private

    def logged_in?
      current_user.present?
    end

    def current_user
      @current_user = find_user_by_token unless defined?(@current_user)
      @current_user
    end

    def find_user_by_token
      UserAuthentication::User.new(klass: ::Users::User)
                              .find(http_auth_token)
    end

    # Raw Authorization Header token (json web token format)
    # JWT's are stored in the Authorization header using this format:
    # Bearer somerandomstring.encoded-payload.anotherrandomstring
    def http_auth_token
      request.headers['Authorization']&.split(' ')&.last
    end
  end
end
