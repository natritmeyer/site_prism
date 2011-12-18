require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

$: << './test_site'
$: << './lib'

require 'prismatic'
require 'test_site'
require 'pages/home'