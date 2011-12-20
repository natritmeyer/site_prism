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
