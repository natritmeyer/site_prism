# frozen_string_literal: true

Then('I can see elements in the section') do
  expect(@test_site.home).to have_people

  expect(@test_site.home.people).to have_headline(text: 'People')
end

Then('I can see a section in a section') do
  expect(@test_site.nested_sections.top.middle)
    .to have_bottom(text: 'something')
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

Then('I can see a welcome header') do
  expect(@test_site.home.welcome_header).to have_content('Welcome')
end

Then('I can see a section within a section using nested blocks') do
  expect(@test_site.nested_sections).to have_top

  @test_site.nested_sections.top do |top|
    expect(top.middle.bottom.text).to eq('something')

    top.middle do |middle|
      expect(middle).to have_bottom(text: 'something')
    end
  end
end

Then('I can see an anonymous section') do
  expect(@test_site.nested_sections.anonymous_section.title.text)
    .to eq('Anonymous Section')
end

Then('the section is visible') do
  expect(@test_site.home.people).to be_visible
end

Then('I can access the sections root element') do
  expect(@test_site.home.people.root_element.class)
    .to eq(Capybara::Node::Element)
end

When('I execute some javascript to set a value') do
  @test_site.nested_sections.search_results.first.cell_value = 'wibble'
end

Then('I can evaluate some javascript to get the value') do
  expect(@test_site.nested_sections.search_results.first.cell_value)
    .to eq('wibble')
end

Then('I can get access to a page through a section') do
  home = @test_site.home

  expect(home.people.parent).to eq(home)
end

Then('I can get a parent section for a child section') do
  top = @test_site.nested_sections.top

  expect(top.middle.parent).to eq(top)
end

Then('I can get access to a page using repeated parent calls') do
  page = @test_site.nested_sections

  expect(page.top.middle.parent.parent).to eq(page)
end

Then('I can get direct access to a page using parent_page') do
  page = @test_site.nested_sections

  expect(page.top.middle.parent_page).to eq(page)
end

Then('the page contains a section with no element') do
  expect(@test_site.home.people).to have_no_dinosaur
end

Then('the page contains a deeply nested span') do
  nested_section = @test_site.nested_sections.level_1.level_2.level_3

  expect(nested_section.deep_span.text).to eq('Deep span')
end

Then("I can see a section's full text") do
  expect(@test_site.home.people.text)
    .to eq('People person 1 person 2 person 3 person 4 object 1')

  expect(@test_site.home.container.text)
    .to eq('This will be removed when you click submit above')
end

Then('I can see elements from the parent section') do
  expect(@test_site.home.people).to have_headline
end

Then('I can see elements from the block') do
  expect(@test_site.home.people).to have_headline_clone
end
