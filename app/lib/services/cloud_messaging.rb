# frozen_string_literal: true

module Services
  class CloudMessaging
    # REDIS_KEY = 'couriers:status:online'
    # TTL_MINUTES = 10

    def notify
      # Rails.logger.info("#{phone}, #{message}")
      notification = FirebaseCloudMessenger::Notification.new(
        title: 'title test',
        body: 'body test'
      )
      token = '12333453'
      message = FirebaseCloudMessenger::Message.new(
        token: token,
        notification: notification
      )
      FirebaseCloudMessenger.send(message: message)
    end

    # private

    # def new_score
    #   score_limit + (TTL_MINUTES * 60)
    # end
  end
end
