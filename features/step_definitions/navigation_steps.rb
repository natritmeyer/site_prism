When /^I navigate to the home page$/ do
  @test_site = TestSite.new
  @test_site.home.load
end

When /^I navigate to the letter A page$/ do
  @test_site = TestSite.new
  @test_site.dynamic_page.load(letter: 'a')
end

Then /^I am on the home page$/ do
  @test_site.home.should be_displayed
end
Then /^I am on a dynamic page$/ do
  @test_site.dynamic_page.should be_displayed
end

When /^I navigate to a page with no title$/ do
  @test_site = TestSite.new
  @test_site.no_title.load
end

When /^I navigate to another page$/ do
  @test_site.page_with_people.load
end

When /^I navigate to the section experiments page$/ do
  @test_site = TestSite.new
  @test_site.section_experiments.load
end

