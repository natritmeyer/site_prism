Then /^I can see elements in the section$/ do
  @test_site.home.should have_people
  @test_site.home.people.title.text.should == "People"
  @test_site.home.people.should have_title :text => "People"
end

Then /^the page does not have section$/ do
  @test_site.home.has_no_nonexistent_section?
  @test_site.home.should have_no_nonexistent_section
end

Then /^that section is there too$/ do
  @test_site.page_with_people.should have_people_list
  @test_site.page_with_people.people_list.title.text.should == "People"
  @test_site.page_with_people.people_list.should have_title :text => "People"
end

Then /^I can see a section within a section$/ do
  @test_site.section_experiments.should have_parent_section
  @test_site.section_experiments.parent_section.should have_child_section
  @test_site.section_experiments.parent_section.child_section.nice_label.text.should == "something"
  @test_site.section_experiments.parent_section.child_section.should have_nice_label :text => "something"
end

Then /^I can see a collection of sections$/ do
  @test_site.section_experiments.should have_search_results
  @test_site.section_experiments.search_results.each_with_index do |search_result, i|
    search_result.title.text.should == "title #{i}"
    search_result.link.text.should == "link #{i}"
    search_result.description.text.should == "description #{i}"
  end
  @test_site.section_experiments.search_results.size.should == 4
  @test_site.section_experiments.should have(4).search_results(:count => 4)
end

Then /^the section is visible$/ do
  @test_site.home.people.should be_visible
end

Then /^I can get at the people section root element$/ do
  @test_site.home.people.root_element.class.should == Capybara::Node::Element
end

Then /^all expected elements are present in the search results$/ do
  @test_site.section_experiments.search_results.first.should be_all_there
end

Then /^I can run javascript against the search results$/ do
  @test_site.section_experiments.search_results.first.set_cell_value
  @test_site.section_experiments.search_results.first.cell_value.should have_content "wibble"
end

Then /^I can see individual people in the people list$/ do
  @test_site.home.people.should have(4).individuals :count => 4
  @test_site.home.people.should have_individuals :count => 4
end

Then /^I can get access to a page through a section$/ do
  home = @test_site.home
  home.people.parent.should eq(home)
end

Then /^I can get a parent section for a child section$/ do
  parent_section = @test_site.section_experiments.parent_section
  parent_section.child_section.parent.should eq(parent_section)
end

Then /^I can get access to a page through a child section$/ do
  page = @test_site.section_experiments
  page.parent_section.child_section.parent.parent.should eq(page)
end

Then /^I can get direct access to a page through a child section$/ do
  page = @test_site.section_experiments
  page.parent_section.child_section.parent_page.should eq(page)
end

Then /^the page contains a section with no element$/ do
  @test_site.home.people.should have_no_dinosaur
end

