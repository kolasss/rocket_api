# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module ShopManager
        class Cancel < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          VALIDATOR = Dry::Validation.Schema do
            required(:reason).filled(:str?)
          end

          def call(id:, shop_id:, params:)
            payload = yield VALIDATOR.call(params).to_monad
            shop = yield find_shop(shop_id)
            order = yield find_order(id, shop)
            yield check_status(order)
            response = order.shop_response
            yield validate_response(response)
            yield update_response(response)
            yield cancel_order(order, payload[:reason])
            yield update_courier(order)
            yield update_client(order)
            Success(order)
          end

          private

          def find_shop(shop_id)
            shop = ::Shops::Shop.where(id: shop_id).first
            if shop.present?
              Success(shop)
            else
              Failure(:shop_not_found)
            end
          end

          def find_order(id, shop)
            order = shop.orders.where(id: id).first
            if order.present?
              Success(order)
            else
              Failure(:order_not_found)
            end
          end

          def check_status(order)
            if order.status != 'requested'
              Failure(:invalid_order_status)
            else
              Success(true)
            end
          end

          def validate_response(response)
            if response.status == 'requested'
              Success(true)
            else
              Failure(:invalid_response_status)
            end
          end

          def update_response(response)
            response.status = 'canceled'
            if response.save
              Success(true)
            else
              Failure(response: response.errors.as_json)
            end
          end

          def cancel_order(order, reason)
            order.cancel_reason = reason
            order.status = 'canceled_shop'
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
            client.active_order = nil

            if client.save
              Success(client)
            else
              Failure(client: client.errors.as_json)
            end
          end
        end
      end
    end
  end
end
