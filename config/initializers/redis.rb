# frozen_string_literal: true

module RocketApi
  class Redis
    def self.config
      @config ||= load_yaml
    end

    def self.load_yaml
      config_path = Rails.root.join('config', 'redis.yml')
      YAML.safe_load(
        ERB.new(File.new(config_path).read).result,
        aliases: true
      )[Rails.env]
    end
  end
end

Redis.current = Redis.new(RocketApi::Redis.config)
