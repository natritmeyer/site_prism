Then /^I can get the page title$/ do
  @test_site.home.title.should == "Home Page"
end

Then /^the page has no title$/ do
  @test_site.no_title.title.should be_nil
end

Then /^I can see the welcome header$/ do
  @test_site.home.should have_welcome_header
  @test_site.home.welcome_header.text.should == "Welcome"
end

Then /^I can see the welcome message$/ do
  @test_site.home.should have_welcome_message
  @test_site.home.welcome_message.text.should == "This is the home page, there is some stuff on it"
end

Then /^I can see the go button$/ do
  @test_site.home.should have_go_button
  @test_site.home.go_button.click
end

Then /^I can see the link to the search page$/ do
  @test_site.home.should have_link_to_search_page
  @test_site.home.link_to_search_page['href'].should include 'search.htm'
end

Then /^I cannot see the missing squirrel$/ do
  using_wait_time(0) do
    @test_site.home.should_not have_squirrel
  end
end

Then /^I cannot see the missing other thingy$/ do
  using_wait_time(0) do
    @test_site.home.should_not have_other_thingy
  end
end

Then /^I can see the group of links$/ do
  @test_site.home.should have_lots_of_links
end

Then /^I can get the group of links$/ do
  @test_site.home.lots_of_links.collect {|link| link.text}.should == ['a', 'b', 'c']
end

Then /^all expected elements are present$/ do
  @test_site.home.should_not be_all_there
end

Then /^an exception is raised when I try to deal with an element with no selector$/ do
  expect {@test_site.no_title.has_element_without_selector?}.to raise_error SitePrism::NoSelectorForElement
  expect {@test_site.no_title.element_without_selector}.to raise_error SitePrism::NoSelectorForElement
  expect {@test_site.no_title.wait_for_element_without_selector}.to raise_error SitePrism::NoSelectorForElement
end

Then /^an exception is raised when I try to deal with elements with no selector$/ do
  expect {@test_site.no_title.has_elements_without_selector?}.to raise_error SitePrism::NoSelectorForElement
  expect {@test_site.no_title.elements_without_selector}.to raise_error SitePrism::NoSelectorForElement
  expect {@test_site.no_title.wait_for_elements_without_selector}.to raise_error SitePrism::NoSelectorForElement
end

When /^I wait until a particular element is visible$/ do
  @test_site.home.wait_until_some_slow_element_visible
end

When /^I wait for a specific amount of time until a particular element is visible$/ do
  @test_site.home.wait_until_shy_element_visible(5)
end

Then /^the previously invisible element is visible$/ do
  @test_site.home.should have_shy_element
end

Then /^I get a timeout error when I wait for an element that never appears$/ do
  expect {@test_site.home.wait_until_invisible_element_visible(1)}.to raise_error SitePrism::TimeOutWaitingForElementVisibility
end

When /^I wait while for an element to become invisible$/ do
  @test_site.home.wait_until_retiring_element_invisible
end

Then /^the previously visible element is invisible$/ do
  @test_site.home.retiring_element.should_not be_visible
end

When /^I wait for a specific amount of time until a particular element is invisible$/ do
  @test_site.home.wait_until_retiring_element_invisible(5)
end

Then /^I get a timeout error when I wait for an element that never disappears$/ do
  expect {@test_site.home.wait_until_welcome_header_invisible(1)}.to raise_error SitePrism::TimeOutWaitingForElementInvisibility
end

