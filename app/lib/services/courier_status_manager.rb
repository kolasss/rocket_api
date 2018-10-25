# frozen_string_literal: true

module Services
  class CourierStatusManager
    READY_KEY = 'couriers:status:ready'
    TTL_MINUTES = 10

    # return couriers ids with time from now to infinity
    def actual
      redis.zrangebyscore(READY_KEY, score_limit, '+inf')
    end

    # store courier id with time = now + ttl
    def add(id)
      redis.zadd(READY_KEY, new_score, id)
    end

    def remove(id)
      redis.zrem(READY_KEY, id)
    end

    # return couriers ids with time older than now
    def outdated
      redis.zrangebyscore(READY_KEY, 0, score_limit)
    end

    # remove couriers ids with time older than now
    def clear_outdated
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
