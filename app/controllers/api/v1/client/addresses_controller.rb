# frozen_string_literal: true

module Api
  module V1
    module Client
      class AddressesController < ApplicationController
        def index
          @addresses = current_user.addresses

          addresses_json = Api::V1::Addresses::Serializer.new(
            @addresses
          ).build_schema

          render json: json_success(items: addresses_json)
        end

        def create
          operation = Operations::V1::Addresses::Client::Create.new
          result = operation.call(
            params: request.parameters,
            client: current_user
          )

          if result.success?
            @address = result.value!
            render(
              json: json_success(serialize_address),
              status: :created
            )
          else
            render_error(
              status: :unprocessable_entity,
              errors: result.failure
            )
          end
        end

        def update
          set_address
          operation = Operations::V1::Addresses::Client::Update.new
          result = operation.call(
            params: request.parameters,
            address: @address
          )

          if result.success?
            @address = result.value!
            render json: json_success(serialize_address)
          else
            render_error(
              status: :unprocessable_entity,
              errors: result.failure
            )
          end
        end

        def destroy
          set_address
          if @address.destroy
            head :no_content
          else
            render_error(
              status: :unprocessable_entity,
              errors: @address.errors.as_json
            )
          end
        end

        private

        def set_address
          @address = current_user.addresses.find(params[:id])
        end

        def serialize_address
          Api::V1::Addresses::Serializer.new(@address).build_schema
        end
      end
    end
  end
end
