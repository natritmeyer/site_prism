# frozen_string_literal: true

When(/^I wait for the element that takes a while to appear$/) do
  @test_site.home.wait_for_some_slow_element
end

Then(/^the slow element appears$/) do
  expect(@test_site.home).to have_some_slow_element
end

When(/^I wait for a short amount of time for an element to appear$/) do
  @test_site.home.wait_for_some_slow_element(1)
end

Then(/^the element I am waiting for doesn't appear in time$/) do
  expect(@test_site.home).not_to have_some_slow_element
end

When(/^I wait for the section element that takes a while to appear$/) do
  @test_site.section_experiments.parent_section.wait_for_slow_section_element
end

Then(/^the slow section appears$/) do
  expect(@test_site.section_experiments.parent_section).to have_slow_section_element
end
