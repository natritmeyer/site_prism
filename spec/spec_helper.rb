# frozen_string_literal: true

require 'simplecov' unless ENV['CI']

require 'capybara'
require 'capybara/dsl'

$LOAD_PATH << './lib'
$LOAD_PATH << './features/support'

require 'site_prism'
require_relative 'fixtures/all'

Capybara.default_max_wait_time = 0

RSpec.configure do |rspec|
  rspec.after(:each) do
    SitePrism.configure do |config|
      config.enable_logging = false
    end
  end

  [CSSPage, XPathPage].each do |klass|
    present_stubs = %i[element_one element_three]
    present_stubs.each do |method|
      rspec.before(:each) do
        allow_any_instance_of(klass).to receive("has_#{method}?") { true }
        allow_any_instance_of(klass).to receive("has_no_#{method}?") { false }
      end
    end
  end
end

class MyTestApp
  def call(_env)
    [200, { 'Content-Length' => '9' }, ['MyTestApp']]
  end
end

Capybara.app = MyTestApp.new
