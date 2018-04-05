# frozen_string_literal: true

module SitePrism
  class Waiter
    def self.wait_until_true(wait_time = Capybara.default_max_wait_time)
      start_time = Time.now

      loop do
        return true if yield
        break if Time.now - start_time > wait_time
        sleep(0.05)
      end

      raise SitePrism::TimeoutException, wait_time
    end

    def self.default_wait_time
      warn 'default_wait_time is now deprecated. This will be removed in an upcoming release.'
      Capybara.default_max_wait_time
    end
  end
end
