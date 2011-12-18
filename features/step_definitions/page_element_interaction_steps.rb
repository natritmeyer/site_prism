Then /^I can get the page title$/ do
  @test_site.home.title.should == "Home Page"
end

Then /^the page has no title$/ do
  @test_site.no_title.title.should be_nil
end
