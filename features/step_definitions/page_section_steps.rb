Then /^I can see elements in the section$/ do
  @test_site.home.people.title.text.should == "People"
end
