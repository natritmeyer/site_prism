# frozen_string_literal: true

When('I wait for the section that takes a while to appear') do
  @test_site.section_experiments.slow_section(wait: 1)
end

When('I wait for the section that takes a while to vanish') do
  @test_site.section_experiments.wait_until_removing_parent_invisible
end

Then("an exception is raised when I wait for a section that won't appear") do
  expect { @test_site.section_experiments.slow_section(wait: 0.05) }
    .to raise_error(Capybara::ElementNotFound)
end

Then('an error is raised when waiting for the section to vanish') do
  page = @test_site.section_experiments

  expect { page.wait_until_anonymous_section_invisible }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end

Then('the removed section is not present') do
  expect(@test_site.section_experiments).not_to have_removing_parent
end

When('I wait an overridden time for the section to vanish') do
  @test_site.section_experiments.wait_until_removing_parent_invisible(wait: 2)
end

Then('the slow section appears') do
  expect(@test_site.section_experiments).to have_slow_section
end

Then('an error is raised when waiting a new time for the section to vanish') do
  page = @test_site.section_experiments

  expect { page.wait_until_anonymous_section_invisible(wait: 0.15) }
    .to raise_error(SitePrism::ElementInvisibilityTimeoutError)
end
