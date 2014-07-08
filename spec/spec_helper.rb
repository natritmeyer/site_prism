require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

$LOAD_PATH << './test_site'
$LOAD_PATH << './lib'

require 'site_prism'
require 'test_site'
require 'sections/people'
require 'sections/no_element_within_section'
require 'sections/container_with_element'
require 'pages/my_iframe'
require 'pages/home'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

class MyTest
  def response
    [200, { 'Content-Length' => '9' }, ['MyTestApp']]
  end
end

class MyTestApp
  def call(_env)
    MyTest.new.response
  end
end

Capybara.app = MyTestApp.new
