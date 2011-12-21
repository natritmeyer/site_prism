Then /^I can see elements in the section$/ do
  @test_site.home.people.title.text.should == "People"
end

Then /^that section is there too$/ do
  @test_site.page_with_people.people_list.title.text.should == "People"
end

Then /^I can see a section within a section$/ do
  @test_site.section_experiments.parent_section.child_section.nice_label.text.should == "something"
end
