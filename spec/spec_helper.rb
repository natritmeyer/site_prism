# frozen_string_literal: true

require 'simplecov' unless ENV['CI']

require 'capybara'
require 'capybara/dsl'

$LOAD_PATH << './lib'
$LOAD_PATH << './features/support'

require 'site_prism'
require 'pages/no_title'

Capybara.default_max_wait_time = 0

RSpec.configure do |rspec|
  rspec.default_formatter = :documentation

  rspec.after(:each) do
    SitePrism.configure do |config|
      config.enable_logging = false
    end
  end
end

class MyTestApp
  def call(_env)
    [200, { 'Content-Length' => '9' }, ['MyTestApp']]
  end
end

Capybara.app = MyTestApp.new
