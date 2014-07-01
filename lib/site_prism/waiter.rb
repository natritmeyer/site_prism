# encoding: utf-8

module SitePrism
  class Waiter
    def self.wait_until_true(wait_time_seconds = default_wait_time)
      start_time = Time.now
      loop do
        return true if yield
        break unless Time.now - start_time <= wait_time_seconds
        sleep(0.05)
      end
      fail SitePrism::TimeoutException.new, 'Timed out while waiting for block to return true'
    end

    def self.default_wait_time
      Capybara.default_wait_time
    end
  end
end
