Then /^I can see an expected bit of the html$/ do
  @test_site.home.html.should include "<span class=\"welcome\">This is the home page"
end

Then /^I can see an expected bit of text$/ do
  @test_site.home.text.should include "This is the home page, there is some stuff on it"
end

Then /^I can see the expected url$/ do
  @test_site.home.current_url.should include "test_site/html/home.htm"
end

Then /^I can see that the page is not secure$/ do
  @test_site.home.should_not be_secure
end

