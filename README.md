Nothing interesting here atm...

So far:
[element, elements, section, sections].each do |thing|
  thing
  has_thing?
  wait_for_thing
  wait_for_thing 10
end

[page, section].each do |thing|
  all_there?
end

Dependencies:
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/cucumber'
  require 'selenium-webdriver'
  require 'rspec'

