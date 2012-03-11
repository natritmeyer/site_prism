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

Then /^an exception is raised when I try to deal with an element with no locator$/ do
  expect {@test_site.no_title.has_element_without_locator?}.to raise_error SitePrism::NoLocatorForElement
  expect {@test_site.no_title.element_without_locator}.to raise_error SitePrism::NoLocatorForElement
  expect {@test_site.no_title.wait_for_element_without_locator}.to raise_error SitePrism::NoLocatorForElement
end

Then /^an exception is raised when I try to deal with elements with no locator$/ do
  expect {@test_site.no_title.has_elements_without_locator?}.to raise_error SitePrism::NoLocatorForElement
  expect {@test_site.no_title.elements_without_locator}.to raise_error SitePrism::NoLocatorForElement
  expect {@test_site.no_title.wait_for_elements_without_locator}.to raise_error SitePrism::NoLocatorForElement
end

