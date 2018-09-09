# frozen_string_literal: true

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'capybara'
require 'capybara/dsl'

$LOAD_PATH << './test_site'
$LOAD_PATH << './lib'

require 'site_prism'
require 'test_site'
require 'sections/people'
require 'sections/blank'
require 'sections/container'
require 'pages/iframe'
require 'pages/home'

Capybara.default_max_wait_time = 0

RSpec.configure do |config|
  config.default_formatter = :documentation
end

class MyTestApp
  def call(_env)
    [200, { 'Content-Length' => '9' }, ['MyTestApp']]
  end
end

Capybara.app = MyTestApp.new
