# frozen_string_literal: true

unless ENV['CI']
  require 'simplecov'
  require 'dotenv'
  SimpleCov.start do
    add_group 'Features', 'features'
    add_group 'Specs', 'spec'
    add_group 'Code', 'lib'
  end
  # Features are currently at 94% on master (Sep 2018)
  SimpleCov.minimum_coverage 92
  SimpleCov.refuse_coverage_drop
  Dotenv.load('.env')
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'

$LOAD_PATH << './lib'

require 'site_prism'

# To prevent natural cucumber load order
require_relative 'sections/all'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: browser)
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.default_max_wait_time = 1.5
  config.app_host = 'file://' + File.dirname(__FILE__) + '/../../test_site'
  config.ignore_hidden_elements = false
end

private

def browser
  ENV.fetch('browser', 'firefox').to_sym
end
