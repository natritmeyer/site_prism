# frozen_string_literal: true

Before do
  @test_site = TestSite.new
end

Before('@slow-speed') do
  Capybara.default_max_wait_time = 0.2
end

Before('@medium-speed') do
  Capybara.default_max_wait_time = 1.2
end

After('@slow-speed or @medium-speed') do
  Capybara.default_max_wait_time = 1.5
end
