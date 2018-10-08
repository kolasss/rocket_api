# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourierStatusCleanupWorker, type: :worker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable false }

  it 'calls clear_old' do
    service = instance_double('Services::CourierStatusManager')
    expect(service).to receive(:clear_old)

    expect(subject).to receive(:service).and_return(service)
    subject.perform
  end
end
