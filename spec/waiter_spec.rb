require 'spec_helper'

describe SitePrism::Waiter do
  describe '#default_wait_time' do
    it 'uses Capybara.default_max_wait_time if available' do
      stub_const('Capybara', double(default_max_wait_time: 1, default_wait_time: 2))
      expect(described_class.default_wait_time).to be 1
    end

    it 'uses Capybara.default_wait_time for older versions of Capybara' do
      stub_const('Capybara', double(default_wait_time: 2))
      expect(described_class.default_wait_time).to be 2
    end
  end

  describe '#wait_until_true' do
    it 'throws a Timeout exception if the block does not become true' do
      allow(described_class).to receive(:default_wait_time).and_return 0
      expect { described_class.wait_until_true { false } }.to raise_error SitePrism::TimeoutException
    end

    it 'returns true if block returns true' do
      allow(described_class).to receive(:default_wait_time).and_return 0
      expect(described_class.wait_until_true { true }).to be true
    end

    it 'allows custom timeouts' do
      allow(described_class).to receive(:default_wait_time).and_return 1
      timeout = 0.1
      start_time = Time.now
      expect { described_class.wait_until_true(timeout) { false } }.to raise_error SitePrism::TimeoutException
      d = Time.now - start_time
      expect(d).to be_within(0.1).of(timeout)
    end
  end
end
