# frozen_string_literal: true

class CourierStatusCleanupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    operation.call
  end

  private

  def operation
    @operation ||= Operations::V1::Couriers::Shifts::AutoStop.new
  end
end
