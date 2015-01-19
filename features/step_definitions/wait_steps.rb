Then(/^when I wait for the element that takes a while to appear$/) do
  @test_site.home.wait_for_some_slow_element
end

Then(/^I successfully wait for it to appear$/) do
  expect(@test_site.home).to have_some_slow_element
end

When(/^I wait for a specifically short amount of time for an element to appear$/) do
  @test_site.home.wait_for_some_slow_element(2)
end

Then(/^the element I am waiting for doesn't appear in time$/) do
  expect(@test_site.home).to_not be_all_there
end

Then(/^when I wait for the section element that takes a while to appear$/) do
  @test_site.section_experiments.parent_section.wait_for_slow_section_element
end

Then(/^I successfully wait for the slow section element to appear$/) do
  expect(@test_site.section_experiments.parent_section).to have_slow_section_element
end
