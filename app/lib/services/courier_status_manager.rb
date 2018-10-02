# frozen_string_literal: true

module Services
  class CourierStatusManager
    READY_KEY = 'couriers:status:ready'
    TTL_MINUTES = 1

    def actual
      redis.zrangebyscore(READY_KEY, score_limit, '+inf')
    end

    def add(id)
      redis.zadd(READY_KEY, new_score, id)
    end

    def remove(id)
      redis.zrem(READY_KEY, id)
    end

    def clear_old
      redis.zremrangebyscore(READY_KEY, 0, score_limit)
    end

    private

    def new_score
      score_limit + (TTL_MINUTES * 60)
    end

    def score_limit
      Time.now.utc.to_i
    end

    def redis
      @redis ||= Redis.current
    end
  end
end
