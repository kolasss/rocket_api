# frozen_string_literal: true

REDIS_CONFIG_PATH = Rails.root.join('config', 'redis.yml')
REDIS_CONFIG = YAML.load_file(REDIS_CONFIG_PATH)

Redis.current = Redis.new(REDIS_CONFIG[Rails.env])
