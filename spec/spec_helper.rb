require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

$: << './test_site'
$: << './lib'

require 'prismatic'
require 'test_site'
require 'sections/people'
require 'pages/home'