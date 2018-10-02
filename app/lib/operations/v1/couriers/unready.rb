# frozen_string_literal: true

module Operations
  module V1
    module Couriers
      class Unready < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        def call(courier)
          yield check_courier(courier)
          make_unready(courier.id.to_s)
        end

        private

        def check_courier(courier)
          if courier.is_a? ::Users::Courier
            Success(true)
          else
            Failure(:user_is_not_courier)
          end
        end

        def make_unready(id)
          service = Services::CourierStatusManager.new
          service.remove(id)
          Success(true)
        end
      end
    end
  end
end
