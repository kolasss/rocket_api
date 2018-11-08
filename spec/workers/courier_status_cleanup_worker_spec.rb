# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourierStatusCleanupWorker, type: :worker do
  subject(:worker) { CourierStatusCleanupWorker.new }

  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable false }

  context 'when perform' do
    let(:result) { MockedResult.new(true) }
    let(:operation) { MockedOperation.new(result) }

    before do
      allow(operation).to receive(:call).and_return(result)
      allow(Operations::V1::Couriers::Shifts::AutoStop).to(
        receive(:new).and_return(operation)
      )
    end

    it 'calls operation' do
      worker.perform
      expect(operation).to have_received(:call).exactly(:once)
    end
  end
end
