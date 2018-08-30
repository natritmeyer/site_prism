# frozen_string_literal: true

Before do
  @test_site = TestSite.new
end

Before('@slow-speed') do
  Capybara.default_max_wait_time = 0.3
end

Before('@medium-speed') do
  Capybara.default_max_wait_time = 1.4
end

After('@slow-speed, @medium-speed') do
  Capybara.default_max_wait_time = 2
end
