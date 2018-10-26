# frozen_string_literal: true

module Services
  class CourierGeopositionManager
    REDIS_KEY = 'couriers:geolocation'

    # return geolocations by ids
    def positions(ids)
      redis.geopos REDIS_KEY, ids
    end

    # return all ids from redis
    def ids
      redis.zrange REDIS_KEY, 0, -1
    end

    # store courier geolocation by id
    def add(lat:, lon:, id:)
      redis.geoadd(REDIS_KEY, lon, lat, id)
    end

    def remove(ids)
      redis.zrem(REDIS_KEY, ids)
    end

    private

    def redis
      @redis ||= Redis.current
    end
  end
end
