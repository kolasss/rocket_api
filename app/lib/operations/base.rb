# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/monads/do'

module Operations
  class Base
    include Dry::Monads::Result::Mixin
  end
end
