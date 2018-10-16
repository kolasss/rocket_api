# frozen_string_literal: true

module Mongoid
  module Geospatial
    class Point
      attr_reader :lat, :lon

      def initialize(lat, lon)
        @lat = self.class.parse_bigdecimal(lat)
        @lon = self.class.parse_bigdecimal(lon)
      end

      # Object -> Database
      # Let's store NilClass if we are invalid.
      def mongoize
        return nil unless @lat && @lon

        self.class.as_geojson(@lat, @lon)
      end

      def as_json
        { lat: @lat.to_f, lon: @lon.to_f }
      end

      class << self
        # Database -> Object
        # {
        #   type: 'Point',
        #   coordinates: [lon, lat]
        # }
        # Get it back
        def demongoize(obj)
          obj && new(obj[:coordinates][1], obj[:coordinates][0])
        end

        # Object -> Database
        # Send it to MongoDB
        def mongoize(obj)
          case obj
          when Point  then obj.mongoize
          # when String then from_string(obj)
          # when Array  then from_array(obj)
          when Hash   then from_hash(obj)
          when NilClass then nil
          else
            raise 'Invalid Point'
          end
        end

        # Converts the object that was supplied to a criteria
        # into a database friendly form.
        def evolve(obj)
          case obj
          when Point then obj.mongoize
          else obj
          end
        end

        # GeoJSON format
        # If specifying latitude and longitude coordinates,
        # list the longitude first and then latitude:
        # Valid longitude values are between -180 and 180, both inclusive.
        # Valid latitude values are between -90 and 90 (both inclusive).
        def as_geojson(lat, lon)
          {
            type: 'Point',
            coordinates: [lon.to_f, lat.to_f]
          }
        end

        # coordinates precision to 5 decimal degrees
        # https://en.wikipedia.org/wiki/Decimal_degrees
        DECIMAL_PRECISION = 5
        PRECISION = 3 + DECIMAL_PRECISION
        def parse_bigdecimal(num)
          BigDecimal(num, PRECISION).round(DECIMAL_PRECISION)
        end

        private

        def from_hash(hsh)
          lat = parse_bigdecimal(hsh[:lat])
          lon = parse_bigdecimal(hsh[:lon])
          as_geojson(lat, lon)
        end
      end
    end
  end
end
