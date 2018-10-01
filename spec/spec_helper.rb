# frozen_string_literal: true

unless ENV['CI']
  require 'simplecov'
end

require 'capybara'
require 'capybara/dsl'

$LOAD_PATH << './lib'
$LOAD_PATH << './features/support'

require 'site_prism'
require 'sections/all'
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
