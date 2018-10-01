# frozen_string_literal: true

module Operations
  module V1
    module Orders
      class Request < ::Operations::V1::Base
        include Dry::Monads::Do.for(:call)

        def call(id:, client:)
          order = yield find_order(id, client)
          yield check_status(order)
          request(order)
        end

        private

        def find_order(id, client)
          order = client.orders.where(id: id).first
          if order.present?
            Success(order)
          else
            Failure(:order_not_found)
          end
        end

        def check_status(order)
          if order.status == 'new'
            Success(true)
          else
            Failure(:invalid_order_status)
          end
        end

        def request(order)
          order.status = 'requested'

          if order.save
            Success(order)
          else
            Failure(order.errors.as_json)
          end
        end
      end
    end
  end
end
