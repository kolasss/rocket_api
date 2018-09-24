# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/monads/do'

module Operations
  module V1
    class Base
      include Dry::Monads::Result::Mixin
    end
  end
end
