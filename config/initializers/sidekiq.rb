# frozen_string_literal: true

unless defined?(REDIS_CONFIG)
  REDIS_CONFIG_PATH = Rails.root.join('config', 'redis.yml')
  REDIS_CONFIG = YAML.load_file(REDIS_CONFIG_PATH)
end

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG[Rails.env]
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG[Rails.env]
end

# ActiveJob::Base.logger = Sidekiq::Logging.logger

Sidekiq::Logging.logger.level = Logger::WARN if Rails.env.production?
