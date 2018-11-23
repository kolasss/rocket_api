# frozen_string_literal: true

module Operations
  module V1
    module Users
      module Common
        class Create < ::Operations::V1::Base
          include Dry::Monads::Do.for(:call, :create)

          VALIDATOR = Dry::Validation.Schema do
            required(:user).schema do
              optional(:name).filled(:str?)
              # required(:phone).filled(:str?, format?: GITHUB_LINK)
              required(:phone).filled(:str?)
              required(:password).filled(:str?)
              required(:role).filled(:str?)
              optional(:shop_id).filled(:str?)

              rule(shop_id: %i[role shop_id]) do |role, shop_id|
                role.eql?('shop_manager') > shop_id.filled?
              end
            end
          end

          def call(params)
            payload = yield VALIDATOR.call(params).to_monad
            role = payload[:user][:role]
            klass = yield detect_class(role)
            yield check_phone(payload[:user][:phone], klass)
            create(
              role: role,
              params: payload[:user],
              klass: klass
            )
          end

          private

          def detect_class(role)
            klass = Services::UserClassDetector.new.common_class(role)
            klass ? Success(klass) : Failure(:invalid_role)
          end

          def check_phone(phone, klass)
            user = klass.where(phone: phone).first
            if user.present?
              Failure(:phone_already_registered)
            else
              Success(true)
            end
          end

          def find_shop(shop_id)
            shop = ::Shops::Shop.where(id: shop_id).first
            if shop.present?
              Success(shop)
            else
              Failure(:shop_not_found)
            end
          end

          def create(role:, params:, klass:)
            case role
            when 'shop_manager'
              shop = yield find_shop(params[:shop_id])
              create_shop_manager(params, klass, shop)
            when 'courier'
              create_courier(params, klass)
            else
              create_user(params, klass)
            end
          end

          def create_user(params, klass)
            user = initialize_user(params, klass)
            save_user(user)
          end

          def create_shop_manager(params, klass, shop)
            user = initialize_user(params, klass)
            user.shop = shop
            save_user(user)
          end

          def create_courier(params, klass)
            user = initialize_user(params, klass)
            user.status = 'offline'
            save_user(user)
          end

          def initialize_user(params, klass)
            klass.new(
              phone: params[:phone],
              name: params[:name],
              password_hash: encrypt_code(params[:password])
            )
          end

          def save_user(user)
            if user.save
              Success(user)
            else
              Failure(user: user.errors.as_json)
            end
          end

          def encrypt_code(code)
            ::UserAuthentication::Code.hash(code)
          end
        end
      end
    end
  end
end
