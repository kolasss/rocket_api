# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = RocketApi::Redis.config
end

Sidekiq.configure_client do |config|
  config.redis = RocketApi::Redis.config
end

# ActiveJob::Base.logger = Sidekiq::Logging.logger

Sidekiq::Logging.logger.level = Logger::WARN if Rails.env.production?
