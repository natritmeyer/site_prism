Then /^I can see an expected bit of the html$/ do
  @test_site.home.html.should include "<span class=\"welcome\">This is the home page"
end

Then /^I can see an expected bit of text$/ do
  @test_site.home.text.should include "This is the home page, there is some stuff on it"
end

