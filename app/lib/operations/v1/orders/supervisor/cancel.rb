# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module Supervisor
        class Cancel < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(id)
            order = yield find_order(id)
            yield check_status(order)
            yield cancel_order(order)
            yield update_courier(order)
            yield update_client(order)
            Success(order)
          end

          private

          def find_order(id)
            order = ::Orders::Order.where(id: id).first
            if order.present?
              Success(order)
            else
              Failure(:order_not_found)
            end
          end

          VALID_STATUSES = %w[
            new
            requested
            accepted
            courier_at_shop
            on_delivery
          ].freeze

          def check_status(order)
            if VALID_STATUSES.include? order.status
              Success(true)
            else
              Failure(:invalid_order_status)
            end
          end

          def cancel_order(order)
            order.status = 'canceled_supervisor'
            if order.save
              Success(true)
            else
              Failure(order: order.errors.as_json)
            end
          end

          # TODO: refactor with courier notification
          def update_courier(order)
            courier = order.courier
            return Success(true) if courier.blank?

            courier.active_order = nil
            courier.status = 'online'
            if courier.save
              Success(true)
            else
              Failure(courier: courier.errors.as_json)
            end
          end

          def update_client(order)
            client = order.client
            return Success(true) if order.id != client.active_order_id

            client.active_order = nil

            if client.save
              Success(true)
            else
              Failure(client: client.errors.as_json)
            end
          end
        end
      end
    end
  end
end
