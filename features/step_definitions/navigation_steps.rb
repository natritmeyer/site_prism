When /^I navigate to the home page$/ do
  @test_site = TestSite.new
  @test_site.home.load
end

Then /^I am on the home page$/ do
  @test_site.home.should be_displayed
end
