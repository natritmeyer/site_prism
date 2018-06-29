# frozen_string_literal: true

Given('exceptions are configured to raise on wait_fors') do
  SitePrism.raise_on_wait_fors = true
end

When('I wait for the element that takes a while to appear') do
  start_time = Time.now
  @test_site.home.wait_for_some_slow_element
  @duration = Time.now - start_time
end

When('I wait for the element that takes a while to disappear') do
  start_time = Time.now
  @test_site.home.wait_for_no_removing_element
  @duration = Time.now - start_time
end

Then('the slow element appears') do
  expect(@test_site.home).to have_some_slow_element
end

Then('the removing element disappears') do
  expect(@test_site.home).not_to have_removing_element
end

When('I wait for a short amount of time for an element to appear') do
  start_time = Time.now
  @test_site.home.wait_for_some_slow_element(1)
  @duration = Time.now - start_time
end

When('I wait for a short amount of time for an element to disappear') do
  start_time = Time.now
  @test_site.home.wait_for_no_removing_element(1)
  @duration = Time.now - start_time
end

Then("an exception is raised when I wait for an element that won't appear") do
  start_time = Time.now

  expect { @test_site.home.wait_for_some_slow_element(1) }
    .to raise_error(SitePrism::TimeOutWaitingForExistenceError)
    .with_message(
      'Timed out after 1s waiting for TestHomePage#some_slow_element'
    )

  @duration = Time.now - start_time

  expect(@duration).to be_between(1, 1.1)
end

Then("an exception is raised when I wait for an element that won't disappear") do
  expect { @test_site.home.wait_for_no_removing_element(1) }
    .to raise_error(SitePrism::TimeOutWaitingForNonExistenceError)
    .with_message(
      'Timed out after 1s waiting for no TestHomePage#removing_element'
    )
end

Then("the element I am waiting for doesn't appear in time") do
  expect(@test_site.home).not_to have_some_slow_element

  expect(@duration).to be_between(1, 1.1)
end

Then("the element I am waiting for doesn't disappear in time") do
  expect(@test_site.home).to have_removing_element

  expect(@duration).to be_between(1, 1.1)
end

When('I wait for the section element that takes a while to appear') do
  @test_site.section_experiments.parent_section.wait_for_slow_section_element
end

When('I wait for the section element that takes a while to disappear') do
  @test_site.section_experiments
            .removing_parent_section
            .wait_for_no_removing_section_element
end

Then('the slow section appears') do
  expect(@test_site.section_experiments.parent_section)
    .to have_slow_section_element
end

Then(/^the removing section disappears$/) do
  expect(@test_site.section_experiments.removing_parent_section)
    .not_to have_removing_section_element
end

Then("an exception is raised when I wait for a section that won't appear") do
  section = @test_site.section_experiments.parent_section

  expect { section.wait_for_slow_section_element(1) }
    .to raise_error(SitePrism::TimeOutWaitingForExistenceError)
    .with_message('Timed out after 1s waiting for Parent#slow_section_element')
end

Then("an exception is raised when I wait for a section that won't disappear") do
  section = @test_site.section_experiments.removing_parent_section
  error_message = 'Timed out after 1s waiting for no Parent#removing_section_element'

  expect { section.wait_for_no_removing_section_element(1) }
    .to raise_error(SitePrism::TimeOutWaitingForNonExistenceError)
    .with_message(error_message)
end

When(/^I wait for the collection of sections that takes a while to disappear$/) do
  @test_site.home.wait_for_no_removing_sections
end

Then(/^the removing collection of sections disappears$/) do
  expect(@test_site.home).not_to have_removing_sections
end

When('I wait a variable time for elements to appear') do
  @test_site.home.wait_for_lots_of_links
  @test_site.home.wait_for_lots_of_links(0.1)
end

When('I wait a variable time for elements to disappear') do
  @test_site.home.wait_for_no_removing_links
  @test_site.home.wait_for_no_removing_links(0.1)
end

Then('I get a timeout error when I wait for an element that never appears') do
  start_time = Time.now

  expect { @test_site.home.wait_until_invisible_element_visible(1) }
    .to raise_error(SitePrism::TimeOutWaitingForElementVisibility)
  @duration = Time.now - start_time

  expect(@duration).to be_between(1, 1.1)
end

When('I wait until a particular element is visible') do
  start_time = Time.now
  @test_site.home.wait_until_some_slow_element_visible
  @duration = Time.now - start_time
end

When('I wait for a specific amount of time until a particular element is visible') do
  @overridden_wait_time = 3.5
  start_time = Time.now
  @test_site.home.wait_until_shy_element_visible(@overridden_wait_time)
  @duration = Time.now - start_time
end

When('I wait for an element to become invisible') do
  @test_site.home.wait_until_retiring_element_invisible
end

When('I wait for a specific amount of time until a particular element is invisible') do
  @test_site.home.wait_until_retiring_element_invisible(5)
end

Then('I get a timeout error when I wait for an element that never disappears') do
  expect { @test_site.home.wait_until_welcome_header_invisible(1) }
    .to raise_error(SitePrism::TimeOutWaitingForElementInvisibility)
end

Then('I am not made to wait for the full default duration') do
  expect(@duration).to be < Capybara.default_max_wait_time
end

Then('I am not made to wait for the full overridden duration') do
  expect(@duration).to be < @overridden_wait_time
end

Then(/^implicit waits are enabled$/) do
  expect(SitePrism.use_implicit_waits).to eq true
end

Then(/^implicit waits are not enabled$/) do
  expect(SitePrism.use_implicit_waits).to eq false
end

Then(/^the slow element is not waited for$/) do
  start_time = Time.now

  expect { @test_site.home.some_slow_element }.to raise_error(Capybara::ElementNotFound)

  expect(Time.now - start_time).to be < 0.5
end

Then(/^the slow element is waited for$/) do
  start_time = Time.now
  @test_site.home.some_slow_element

  expect(Time.now - start_time).to be > 1.5
end

Then(/^the slow elements are waited for$/) do
  start_time = Time.now
  @test_site.home.slow_elements(count: 1)
  expect(Time.now - start_time).to be > 1.5
end

Then(/^the slow elements are not waited for$/) do
  start_time = Time.now
  expect { @test_site.home.slow_elements(count: 1) }.to raise_error(Capybara::ElementNotFound)
  expect(Time.now - start_time).to be < 0.5
end
