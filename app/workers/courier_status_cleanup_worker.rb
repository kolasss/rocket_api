# frozen_string_literal: true

class CourierStatusCleanupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    service = Services::CourierStatusManager.new
    service.clear_old
  end
end
