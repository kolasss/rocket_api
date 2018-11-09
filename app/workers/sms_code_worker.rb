# frozen_string_literal: true

class SmsCodeWorker
  include Sidekiq::Worker

  def perform(phone, message)
    service.send(phone, message)
  end

  private

  def service
    @service ||= Services::Sms.new
  end
end
