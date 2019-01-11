# frozen_string_literal: true

When('I wait for the element that takes a while to appear') do
  @overridden_wait_time = 1.6
  start_time = Time.now
  @test_site.slow.last_link(wait: @overridden_wait_time)
  @duration = Time.now - start_time
end

Then('the slow element appears') do
  expect(@test_site.slow).to have_last_link
end

Then("an exception is raised when I wait for an element that won't appear") do
  start_time = Time.now

  expect { @test_site.slow.last_link(wait: 0.1) }
    .to raise_error(Capybara::ElementNotFound)

  @duration = Time.now - start_time

  expect(@duration).to be_between(0.1, 0.3)
end

Then('I get an error when I wait for an element to vanish within the limit') do
  expect { @test_site.home.wait_until_header_invisible(wait: 0.25) }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

Then("an exception is raised when I wait for an element that won't vanish") do
  expect { @test_site.home.wait_until_header_invisible }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

Then('I can wait a variable time for elements to disappear') do
  expect { @test_site.vanishing.removed_elements(wait: 0.7, count: 0) }
    .not_to raise_error

  expect(@test_site.vanishing).to have_no_removed_elements
end

Then('I get a timeout error when waiting for an element within the limit') do
  start_time = Time.now

  expect { @test_site.slow.wait_until_invisible_visible(wait: 0.2) }
    .to raise_error(SitePrism::ElementVisibilityTimeoutError)
  @duration = Time.now - start_time

  expect(@duration).to be_between(0.2, 0.4)
end

Then('I get a timeout error when waiting for an element with default limit') do
  expect { @test_site.slow.wait_until_invisible_visible }
    .to raise_error(SitePrism::ElementVisibilityTimeoutError)
end

When('I wait until a particular element is visible') do
  start_time = Time.now
  @test_site.slow.wait_until_last_link_visible
  @duration = Time.now - start_time
end

Then('the previously invisible element is visible') do
  expect(@test_site.slow.last_link).to be_visible
end

When('I wait for a specific amount of time until an element is visible') do
  @overridden_wait_time = 3.5
  start_time = Time.now
  @test_site.slow.wait_until_last_link_visible(wait: @overridden_wait_time)
  @duration = Time.now - start_time
end

When('I wait for an element to become invisible') do
  @test_site.vanishing.wait_until_delayed_invisible
end

When('I wait a specific amount of time for a particular element to vanish') do
  @test_site.vanishing.wait_until_delayed_invisible(wait: 0.75)
end

Then('I am not made to wait for the full default duration') do
  expect(@duration).to be < Capybara.default_max_wait_time
end

Then('I am not made to wait for the full overridden duration') do
  expect(@duration).to be < @overridden_wait_time
end

Then('I can override the wait time using a Capybara.using_wait_time block') do
  start_time = Time.now
  Capybara.using_wait_time(0.1) do
    expect { @test_site.slow.last_link }
      .to raise_error(Capybara::ElementNotFound)
  end
  @duration = Time.now - start_time

  expect(@duration).to be_between(0.1, 0.3)
end

Then('I am not made to wait to check a nonexistent element for invisibility') do
  start = Time.new
  @test_site.home.wait_until_nonexistent_element_invisible(wait: 10)

  expect(Time.new - start).to be < 1
end

Then('an error is thrown when waiting for an element in a vanishing section') do
  expect do
    @test_site.vanishing.container.wait_until_embedded_invisible
  end.to raise_error(Capybara::ElementNotFound)
end
