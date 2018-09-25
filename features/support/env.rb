# frozen_string_literal: true

unless ENV['CI']
  require 'simplecov'
  require 'dotenv'
  SimpleCov.start
  Dotenv.load('.env')
end

require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'

$LOAD_PATH << './test_site'
$LOAD_PATH << './lib'

require 'site_prism'
require 'test_site'
require 'sections/people'
require 'sections/blank'
require 'sections/container'
require 'sections/child'
require 'sections/parent_div'
require 'sections/search_results'
require 'sections/vanishing_parent'
require 'pages/iframe'
require 'pages/home'
require 'pages/home_with_expected_elements'
require 'pages/dynamic_page'
require 'pages/no_title'
require 'pages/redirect'
require 'pages/section_experiments'

Capybara.configure do |config|
  config.default_driver = :selenium
  config.default_max_wait_time = 2
  config.app_host = 'file://' + File.dirname(__FILE__) + '/../../test_site/html'
  config.ignore_hidden_elements = false
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: browser)
end

private

def browser
  ENV.fetch('browser', 'firefox').to_sym
end
