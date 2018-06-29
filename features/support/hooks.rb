# frozen_string_literal: true

Before('~@implicit_waits') do
  SitePrism.configure do |config|
    config.use_implicit_waits = false
  end
end

Before('@implicit_waits') do
  SitePrism.configure do |config|
    config.use_implicit_waits = true
  end
end

Before do
  SitePrism.raise_on_wait_fors = false
  @test_site = TestSite.new
end
