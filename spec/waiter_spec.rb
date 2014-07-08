require 'spec_helper'

describe SitePrism::Page do
  it 'should have a default wait time greater than 0' do
    expect(SitePrism::Waiter.default_wait_time).to be > 0
  end

  it 'should have respond to wait_until_true' do
    expect(SitePrism::Waiter).to respond_to :wait_until_true
  end

  it 'should throw a Timeout exception if the block does not become true' do
    expect { SitePrism::Waiter.wait_until_true { false } }.to raise_error SitePrism::TimeoutException
  end

  it 'should return true if block returns true' do
    expect(SitePrism::Waiter.wait_until_true { true }).to be true
  end

  it 'should allow custom timeouts' do
    timeout = (SitePrism::Waiter.default_wait_time >= 2) ? SitePrism::Waiter.default_wait_time / 2 : 3
    start_time = Time.now
    expect { SitePrism::Waiter.wait_until_true(timeout) { false } }.to raise_error SitePrism::TimeoutException
    d = Time.now - start_time
    expect(d).to be >= timeout.to_f
    expect(d).to be <= SitePrism::Waiter.default_wait_time.to_f
  end
end
