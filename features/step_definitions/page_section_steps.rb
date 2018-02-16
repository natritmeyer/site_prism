Then(/^I can see elements in the section$/) do
  expect(@test_site.home).to have_people
  expect(@test_site.home.people.headline).to have_content('People')
  expect(@test_site.home.people).to have_headline(text: 'People')
end

Then(/^I can see a section in a section$/) do
  expect(@test_site.section_experiments.parent_section.child_section).to have_nice_label(text: 'something')
end

Then(/^I can access elements within the section using a block$/) do
  expect(@test_site.home).to have_people

  @test_site.home.people do |persons|
    expect(persons).to have_headline(text: 'People')
    expect(persons.headline.text).to eq('People')
    expect(persons).to have_no_dinosaur
    expect(persons).to have_individuals(count: 4)
  end

  # the above would pass if the block were ignored, this verifies it is executed:
  expect do
    @test_site.home.people { |p| expect(p).to have_dinosaur }
  end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Then(/^access to elements is constrained to those within the section$/) do
  expect(@test_site.home).to have_css('span.welcome')

  @test_site.home.people do |persons|
    expect(persons).to have_no_css('.welcome')
    expect { persons.has_welcome_message? }.to raise_error(NoMethodError)
    expect(persons).to have_no_welcome_message_on_the_parent
  end
end

Then(/^the page does not have a section$/) do
  expect(@test_site.home.has_no_nonexistent_section?).to be true

  expect(@test_site.home).to have_no_nonexistent_section
end

Then(/^that section is there too$/) do
  expect(@test_site.page_with_people).to have_people_list
  expect(@test_site.page_with_people.people_list.headline).to have_content('People')
  expect(@test_site.page_with_people.people_list).to have_headline(text: 'People')
end

Then(/^I can see a section within a section$/) do
  expect(@test_site.section_experiments).to have_parent_section
  expect(@test_site.section_experiments.parent_section).to have_child_section
  expect(@test_site.section_experiments.parent_section.child_section.nice_label.text).to eq('something')
  expect(@test_site.section_experiments.parent_section.child_section).to have_nice_label(text: 'something')
end

Then(/^I can see a section within a section using nested blocks$/) do
  expect(@test_site.section_experiments).to have_parent_section

  @test_site.section_experiments.parent_section do |parent|
    expect(parent).to have_child_section
    expect(parent.child_section.nice_label.text).to eq('something')
    parent.child_section do |child|
      expect(child).to have_nice_label(text: 'something')
    end
  end
end

Then(/^I can see a collection of sections$/) do
  expect(@test_site.section_experiments).to have_search_results

  @test_site.section_experiments.search_results.each_with_index do |search_result, i|
    expect(search_result.title.text).to eq("title #{i}")
    expect(search_result.link.text).to eq("link #{i}")
    expect(search_result.description.text).to eq("description #{i}")
  end
  expect(@test_site.section_experiments.search_results.size).to eq(4)

  expect(@test_site.section_experiments.search_results(count: 4).size).to eq(4)
end

Then(/^I can see an anonymous section$/) do
  expect(@test_site.section_experiments).to have_anonymous_section
  expect(@test_site.section_experiments.anonymous_section.title.text).to eq('Anonymous Section')
  expect(@test_site.section_experiments.anonymous_section.upcase_title_text).to eq('ANONYMOUS SECTION')
end

Then(/^I can see a collection of anonymous sections$/) do
  expect(@test_site.section_experiments).to have_anonymous_section

  @test_site.section_experiments.anonymous_sections.each_with_index do |section, i|
    expect(section.title.text).to eq("Section #{i}")
    expect(section.downcase_title_text).to eq("section #{i}")
  end

  expect(@test_site.section_experiments.anonymous_sections.size).to eq(2)

  expect(@test_site.section_experiments.anonymous_sections(count: 2).size).to eq(2)
end

Then(/^the section is visible$/) do
  expect(@test_site.home.people).to be_visible
end

Then(/^I can get at the people section root element$/) do
  expect(@test_site.home.people.root_element.class).to eq(Capybara::Node::Element)
end

Then(/^all expected elements are present in the search results$/) do
  expect(@test_site.section_experiments.search_results.first).to be_all_there
end

Then(/^I can run javascript against the search results$/) do
  @test_site.section_experiments.search_results.first.set_cell_value
  expect(@test_site.section_experiments.search_results.first.cell_value).to eq('wibble')
  expect(@test_site.section_experiments.search_results.first.cell_value).to have_content('wibble')
end

Then(/^I can see individual people in the people list$/) do
  expect(@test_site.home.people.individuals.size).to eq(4)
  expect(@test_site.home.people.individuals(count: 4).size).to eq(4)
  expect(@test_site.home.people).to have_individuals count:(4)
end

Then(/^I can get access to a page through a section$/) do
  home = @test_site.home

  expect(home.people.parent).to eq(home)
end

Then(/^I can get a parent section for a child section$/) do
  parent_section = @test_site.section_experiments.parent_section

  expect(parent_section.child_section.parent).to eq(parent_section)
end

Then(/^I can get access to a page through a child section$/) do
  page = @test_site.section_experiments

  expect(page.parent_section.child_section.parent.parent).to eq(page)
end

Then(/^I can get direct access to a page through a child section$/) do
  page = @test_site.section_experiments

  expect(page.parent_section.child_section.parent_page).to eq(page)
end

Then(/^the page contains a section with no element$/) do
  expect(@test_site.home.people).to have_no_dinosaur
end

Then(/^the page contains a deeply nested span$/) do
  expect(@test_site.section_experiments.level_1[0].level_2[0].level_3[0].level_4[0].level_5[0]).to have_deep_span
  expect(@test_site.section_experiments.level_1[0].level_2[0].level_3[0].level_4[0].level_5[0].deep_span.text).to eq 'Deep span'
end

Then(/^I can see a section's full text$/) do
  expect(@test_site.home.people.text).to eq('People person 1 person 2 person 3 person 4')

  expect(@test_site.home.container_with_element.text).to eq('')
end
