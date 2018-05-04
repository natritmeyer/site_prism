# frozen_string_literal: true

Then('I can see elements in the section') do
  expect(@test_site.home).to have_people

  expect(@test_site.home.people).to have_headline(text: 'People')
end

Then('I can see a section in a section') do
  expect(@test_site.section_experiments.parent_section.child_section).to have_nice_label(text: 'something')
end

Then('I can access elements within the section using a block') do
  expect(@test_site.home).to have_people

  @test_site.home.people do |section|
    expect(section.headline.text).to eq('People')

    expect(section).to have_individuals(count: 4)
  end
end

Then('I cannot access elements that are not in the section using a block') do
  expect do
    @test_site.home.people { |section| expect(section).to have_dinosaur }
  end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Then('access to elements is constrained to those within the section') do
  expect(@test_site.home).to have_css('.welcome')

  expect(@test_site.home.has_welcome_message?).to be true

  @test_site.home.people do |section|
    expect(section).to have_no_css('.welcome')

    expect { section.has_welcome_message? }.to raise_error(NoMethodError)
  end
end

Then('the page does not have a section') do
  expect(@test_site.home.has_no_nonexistent_section?).to be true

  expect(@test_site.home).to have_no_nonexistent_section
end

Then('I can see a list of people') do
  expect(@test_site.page_with_people.people_list.headline).to have_content('People')
end

Then('I can see a section within a section using nested blocks') do
  expect(@test_site.section_experiments).to have_parent_section

  @test_site.section_experiments.parent_section do |parent|
    expect(parent.child_section.nice_label.text).to eq('something')

    parent.child_section do |child|
      expect(child).to have_nice_label(text: 'something')
    end
  end
end

Then('I can see an anonymous section') do
  expect(@test_site.section_experiments.anonymous_section.title.text).to eq('Anonymous Section')
end

Then('the section is visible') do
  expect(@test_site.home.people).to be_visible
end

Then('I can access the sections root element') do
  expect(@test_site.home.people.root_element.class).to eq(Capybara::Node::Element)
end

When('I execute some javascript to set a value') do
  @test_site.section_experiments.search_results.first.cell_value = 'wibble'
end

Then('I can evaluate some javascript to get the value') do
  expect(@test_site.section_experiments.search_results.first.cell_value).to eq('wibble')
end

Then('I can get access to a page through a section') do
  home = @test_site.home

  expect(home.people.parent).to eq(home)
end

Then('I can get a parent section for a child section') do
  parent_section = @test_site.section_experiments.parent_section

  expect(parent_section.child_section.parent).to eq(parent_section)
end

Then('I can get access to a page through a child section') do
  page = @test_site.section_experiments

  expect(page.parent_section.child_section.parent.parent).to eq(page)
end

Then('I can get direct access to a page through a child section') do
  page = @test_site.section_experiments

  expect(page.parent_section.child_section.parent_page).to eq(page)
end

Then('the page contains a section with no element') do
  expect(@test_site.home.people).to have_no_dinosaur
end

Then('the page contains a deeply nested span') do
  deeply_nested_section =
    @test_site.section_experiments.level_1[0].level_2[0].level_3[0].level_4[0].level_5[0]

  expect(deeply_nested_section.deep_span.text).to eq('Deep span')
end

Then("I can see a section's full text") do
  expect(@test_site.home.people.text).to eq('People person 1 person 2 person 3 person 4')

  expect(@test_site.home.container_with_element.text).to eq('This will be removed when you click submit above')
end
