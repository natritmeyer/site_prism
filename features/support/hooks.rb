# frozen_string_literal: true

Before('not @implicit_waits') do
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
  @test_site = TestSite.new
end
