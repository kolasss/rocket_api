# frozen_string_literal: true

module Users
  module Couriers
    class Shift
      include Mongoid::Document
      field :started_at, type: DateTime
      field :ended_at, type: DateTime
      field :delivered, type: Integer, default: 0

      embedded_in(
        :courier,
        class_name: 'Users::Courier',
        inverse_of: :shifts
      )

      def self.current
        where(ended_at: nil).order_by(started_at: :desc).first
      end
    end
  end
end
