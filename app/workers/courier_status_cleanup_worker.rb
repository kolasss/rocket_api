# frozen_string_literal: true

class CourierStatusCleanupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    service.clear_old
  end

  private

  def service
    @service ||= Services::CourierStatusManager.new
  end
end
