# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Waiter do
  describe '.wait_until_true' do
    it 'throws a Timeout exception if the block does not become true' do
      allow(Capybara).to receive(:default_max_wait_time).and_return(0.1)

      expect { described_class.wait_until_true { false } }
        .to raise_error(SitePrism::TimeoutException)
        .with_message(/0.1/)
    end

    it 'returns true if block returns true' do
      expect(described_class.wait_until_true { true }).to be true
    end

    it 'allows custom timeouts' do
      timeout = 0.2
      start_time = Time.now

      expect { described_class.wait_until_true(timeout) { false } }
        .to raise_error(SitePrism::TimeoutException)
        .with_message(/0.2/)

      duration = Time.now - start_time

      expect(duration).to be_within(0.1).of(timeout)
    end
  end
end
