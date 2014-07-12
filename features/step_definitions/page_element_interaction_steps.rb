Then /^I can get the page title$/ do
  @test_site.home.title.should == "Home Page"
end

Then /^the page has no title$/ do
  @test_site.no_title.title.should == ""
end

Then /^the page does not have element$/ do
  @test_site.home.has_no_nonexistent_element?
  @test_site.home.should have_no_nonexistent_element
end

Then /^the page does not have elements$/ do
  @test_site.home.has_no_nonexistent_elements?
  @test_site.home.should have_no_nonexistent_elements
end

Then /^I can see the welcome header$/ do
  @test_site.home.should have_welcome_header
  @test_site.home.welcome_header.text.should == "Welcome"
end

Then /^I can see the welcome header with capybara query options$/ do
  @test_site.home.should have_welcome_header
  @test_site.home.should have_welcome_header :text => "Welcome"
  expect { @test_site.home.welcome_header :text => "Welcome" }.to_not raise_error
end

Then /^the welcome header is not matched with invalid text$/ do
  @test_site.home.should have_no_welcome_header(:text => "This Doesn't Match!")
end

Then /^I can see the welcome message$/ do
  @test_site.home.should have_welcome_message
  @test_site.home.welcome_message.text.should == "This is the home page, there is some stuff on it"
end

Then /^I can see the welcome message with capybara query options$/ do
  @test_site.home.should have_welcome_message
  @test_site.home.should have_welcome_message :text => "This is the home page, there is some stuff on it"
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

Then /^I do not wait for an nonexistent element when checking for invisibility$/ do
  start = Time.new
  @test_site.home.wait_until_nonexistent_element_invisible(10)
  (Time.new - start).should < 1
end

When /^I wait for invisibility of an element embedded into a section which is removed$/ do
  @test_site.home.remove_container_with_element_btn.click
end

Then /^I receive an error when a section with the element I am waiting for is removed$/ do
  expect {@test_site.home.container_with_element.wait_until_embedded_element_invisible}.to raise_error Capybara::ElementNotFound
end

Then /^I can wait a variable time for elements to appear$/ do
  @test_site.home.wait_for_lots_of_links
  @test_site.home.wait_for_lots_of_links(0.1)
end

Then /^I can wait a variable time and pass specific parameters$/ do
  @test_site.home.wait_for_lots_of_links(0.1, count: 2)
  Capybara.using_wait_time 0.3 do
    # intentionally wait and pass nil to force this to cycle
    expect(@test_site.home.wait_for_lots_of_links(nil, count: 19810814)).to be false
  end
end

