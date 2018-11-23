# frozen_string_literal: true

class CourierAssignmentAutodeclineWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(courier_id, order_id)
    result = operation.call(courier_id, order_id)
    return if result.success?

    Rails.logger.error("CourierAssignmentAutodeclineWorker: #{result.failure}")
  end

  private

  def operation
    @operation ||= Operations::V1::Orders::Courier::AutoDecline.new
  end
end
