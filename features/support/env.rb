require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'

$: << './test_site'
$: << './lib'

require 'prismatic'
require 'test_site'
require 'sections/people'
require 'pages/home'
require 'pages/no_title'
require 'pages/page_with_people'

Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium
  config.run_server = false
  config.default_selector = :css
  config.default_wait_time = 5
  config.app_host = "file:///Users/nat/github/prismatic/test_site/html"
end

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["browser.cache.disk.enable"] = false
  profile["browser.cache.memory.enable"] = false
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end

World(Capybara)

Capybara.run_server = false