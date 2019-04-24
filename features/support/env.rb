# frozen_string_literal: true

unless ENV['CI']
  require 'simplecov'
  require 'dotenv'
  Dotenv.load('.env')
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'webdrivers'

$LOAD_PATH << './lib'

require 'site_prism'

# To prevent natural cucumber load order
require_relative 'js_helper'
require_relative 'sections/all'

Capybara.register_driver :selenium do |app|
  browser = ENV.fetch('browser', 'firefox').to_sym
  Capybara::Selenium::Driver.new(app, browser: browser)
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.default_max_wait_time = 0.75
  config.app_host = 'file://' + File.dirname(__FILE__) + '/../../test_site'
  config.ignore_hidden_elements = false
end
