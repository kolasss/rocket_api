# frozen_string_literal: true

class CourierStatusCleanupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    result = operation.call
    return if result.success?

    Rails.logger.error("CourierStatusCleanupWorker: #{result.failure}")
  end

  private

  def operation
    @operation ||= Operations::V1::Couriers::Shifts::AutoStop.new
  end
end
