# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourierStatusCleanupWorker, type: :worker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable false }

  it 'calls clear_old' do
    operation = instance_double('Operations::V1::Couriers::Shifts::AutoStop')
    expect(operation).to receive(:call)

    expect(subject).to receive(:operation).and_return(operation)
    subject.perform
  end
end
