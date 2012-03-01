Then /^when I wait for the element that takes a while to appear$/ do
  @test_site.home.wait_for_some_slow_element
end

Then /^I successfully wait for it to appear$/ do
  @test_site.home.should have_some_slow_element
end

