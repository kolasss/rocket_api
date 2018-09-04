# frozen_string_literal: true

module Faker
  class UniqueGenerator
    # redefine to fix a bug, delete when PR will be merged
    # https://github.com/stympy/faker/pull/1355
    def self.clear
      marked_unique.each(&:clear)
    end
  end
end
