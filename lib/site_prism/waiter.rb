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

      raise SitePrism::TimeoutError, "Timed out after #{wait_time}s."
    end
  end
end
