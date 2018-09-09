# frozen_string_literal: true

When('I wait for the element that takes a while to appear') do
  start_time = Time.now
  @test_site.home.some_slow_element(wait: 2)
  @duration = Time.now - start_time
end

When('I wait for the element that takes a while to disappear') do
  start_time = Time.now
  @test_site.home.wait_until_removing_element_invisible
  @duration = Time.now - start_time
end

Then('the slow element appears') do
  expect(@test_site.home).to have_some_slow_element
end

Then('the removing element disappears') do
  expect(@test_site.home).not_to have_removing_element
end

Then("an exception is raised when I wait for an element that won't appear") do
  start_time = Time.now

  expect { @test_site.home.some_slow_element(wait: 1) }
    .to raise_error(Capybara::ElementNotFound)

  @duration = Time.now - start_time

  expect(@duration).to be_between(1, 1.15)
end

Then("an exception is raised when I wait for an element that won't vanish") do
  expect { @test_site.home.wait_until_removing_element_invisible(wait: 1) }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

When('I wait for the section element that takes a while to appear') do
  @test_site.section_experiments.parent_section.slow_element(wait: 1)
end

When('I wait for the section element that takes a while to disappear') do
  section = @test_site.section_experiments.removing_parent
  section.wait_until_removing_element_invisible
end

Then('the slow section appears') do
  expect(@test_site.section_experiments.parent_section)
    .to have_slow_element
end

Then('the removing section disappears') do
  expect(@test_site.section_experiments.removing_parent)
    .not_to have_removing_element
end

Then("an exception is raised when I wait for a section that won't appear") do
  expect { @test_site.section_experiments.slow_section(wait: 0.05) }
    .to raise_error(Capybara::ElementNotFound)
end

Then("an exception is raised when I wait for a section that won't disappear") do
  page = @test_site.section_experiments

  expect { page.wait_until_anonymous_section_invisible(wait: 0.15) }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

When('I wait for the collection of sections that takes a while to disappear') do
  @test_site.home.wait_until_removing_sections_invisible
end

Then('the removing collection of sections disappears') do
  expect(@test_site.home).not_to have_removing_sections
end

Then('I can wait a variable time for elements to disappear') do
  expect { @test_site.home.removing_links(wait: 1.9, count: 0) }
    .not_to raise_error

  expect(@test_site.home).to have_no_removing_links
end

Then('I get a timeout error when I wait for an element that never appears') do
  start_time = Time.now

  expect { @test_site.home.wait_until_invisible_element_visible(wait: 1) }
    .to raise_error(SitePrism::ElementVisibilityTimeoutError)
  @duration = Time.now - start_time

  expect(@duration).to be_between(1, 1.15)
end

When('I wait until a particular element is visible') do
  start_time = Time.now
  @test_site.home.wait_until_some_slow_element_visible
  @duration = Time.now - start_time
end

When('I wait for a specific amount of time until an element is visible') do
  @overridden_wait_time = 3.5
  start_time = Time.now
  @test_site.home.wait_until_shy_element_visible(wait: @overridden_wait_time)
  @duration = Time.now - start_time
end

When('I wait for an element to become invisible') do
  @test_site.home.wait_until_retiring_element_invisible
end

When('I wait a specific amount of time for a particular element to vanish') do
  @test_site.home.wait_until_retiring_element_invisible(wait: 5)
end

Then('I get a timeout error when I wait for an element that never vanishes') do
  expect { @test_site.home.wait_until_welcome_header_invisible(wait: 1) }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

Then('I am not made to wait for the full default duration') do
  expect(@duration).to be < Capybara.default_max_wait_time
end

Then('I am not made to wait for the full overridden duration') do
  expect(@duration).to be < @overridden_wait_time
end

Then('I can override the wait time using a Capybara.using_wait_time block') do
  start_time = Time.now
  Capybara.using_wait_time(1) do
    expect { @test_site.home.some_slow_element }
      .to raise_error(Capybara::ElementNotFound)
  end
  @duration = Time.now - start_time

  expect(@duration).to be_between(1, 1.15)
end
