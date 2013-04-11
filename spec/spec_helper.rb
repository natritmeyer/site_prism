require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

$: << './test_site'
$: << './lib'

require 'site_prism'
require 'test_site'
require 'sections/people'
require 'sections/no_element_within_section'
require 'sections/container_with_element'
require 'pages/my_iframe'
require 'pages/home'

