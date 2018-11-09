# frozen_string_literal: true

module Services
  class Sms
    # REDIS_KEY = 'couriers:status:online'
    # TTL_MINUTES = 10

    def send(phone, message)
      Rails.logger.info("#{phone}, #{message}")
    end

    # private

    # def new_score
    #   score_limit + (TTL_MINUTES * 60)
    # end
  end
end
