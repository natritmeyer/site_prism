require 'spec_helper'

describe SitePrism::Page do
  it 'should have a default wait time greater than 0' do
    expect(SitePrism::Waiter.default_wait_time).to be > 0
  end

  it 'should have respond to wait_until_true' do
    expect(SitePrism::Waiter).to respond_to :wait_until_true
  end

  context "with stubbed timeout" do
    before { allow(SitePrism::Waiter).to receive(:default_wait_time).and_return 0 }

    it 'should throw a Timeout exception if the block does not become true' do
      expect { SitePrism::Waiter.wait_until_true { false } }.to raise_error SitePrism::TimeoutException
    end

    it 'should return true if block returns true' do
      expect(SitePrism::Waiter.wait_until_true { true }).to be true
    end
  end

  it 'should allow custom timeouts' do
    timeout = (SitePrism::Waiter.default_wait_time >= 2) ? SitePrism::Waiter.default_wait_time / 2 : 3
    timeout = 0.1
    margin_of_error = timeout * 0.25
    start_time = Time.now
    expect { SitePrism::Waiter.wait_until_true(timeout) { false } }.to raise_error SitePrism::TimeoutException
    d = Time.now - start_time
    expect(d).to be_within(margin_of_error).of(timeout)
  end
end
