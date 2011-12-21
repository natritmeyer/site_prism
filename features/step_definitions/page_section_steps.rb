Then /^I can see elements in the section$/ do
  @test_site.home.people.title.text.should == "People"
end

Then /^that section is there too$/ do
  @test_site.page_with_people.people_list.title.text.should == "People"
end

Then /^I can see a section within a section$/ do
  @test_site.section_experiments.parent_section.child_section.nice_label.text.should == "something"
end

Then /^I can see a collection of sections$/ do
  @test_site.section_experiments.search_results.each_with_index do |search_result, i|
    search_result.title.text.should == "title #{i}"
    search_result.link.text.should == "link #{i}"
    search_result.description.text.should == "description #{i}"
  end
  @test_site.section_experiments.search_results.size.should == 4
end
