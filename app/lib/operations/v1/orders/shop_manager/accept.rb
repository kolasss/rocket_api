# frozen_string_literal: true

module Operations
  module V1
    module Orders
      module ShopManager
        class Accept < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call)

          def call(id:, shop_id:)
            shop = yield find_shop(shop_id)
            order = yield find_order(id, shop)
            yield check_order(order)
            response = order.shop_response
            yield validate_response(response)
            yield update_response(response)
            update_order(order)
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

          def check_order(order)
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
            response.status = 'accepted'
            if response.save
              Success(true)
            else
              Failure(response: response.errors.as_json)
            end
          end

          def update_order(order)
            return Success(order) if order.courier_id.blank?

            assignment = current_assignment(order)
            return Success(order) if assignment.blank?

            order.update(status: 'accepted') if assignment.status == 'accepted'
            Success(order)
          end

          def current_assignment(order)
            order.courier_assignments.where(courier_id: order.courier_id).first
          end
        end
      end
    end
  end
end
