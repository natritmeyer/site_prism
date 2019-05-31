# frozen_string_literal: true

Then('the page does not have element') do
  expect(@test_site.home.has_no_nonexistent_element?).to be true

  expect(@test_site.home).to have_no_nonexistent_element
end

Then('I can see the welcome header') do
  expect(@test_site.home).to have_header

  expect(@test_site.home.header.text).to eq('Home Page!')
end

Then('I can see the welcome header using a capybara text query') do
  expect(@test_site.home).to have_header(text: 'Home Page!')
end

Then('I can see a person using a capybara class query') do
  expect(@test_site.home).to have_list_of_people(class: 'andy')
end

Then('I can see the first person') do
  expect(@test_site.home).to have_list_of_people

  expect(@test_site.home.list_of_people.first.text).to eq('Andy')
end

Then('the welcome header is not matched with invalid text') do
  expect(@test_site.home).to have_no_header(text: "This Doesn't Match!")
end

Then('I can see the welcome message') do
  expect(@test_site.home).to have_welcome_message

  expect(@test_site.home.welcome_message.text)
    .to eq('This is the home page, there is some stuff on it')
end

Then('I can see the welcome message using a capybara text query') do
  sample_text = 'This is the home page, there is some stuff on it'

  expect(@test_site.home).to have_welcome_message(text: sample_text)
end

Then('I can see the the HREF of the link') do
  expect(@test_site.home).to have_a_link

  expect(@test_site.home.a_link['href']).to end_with('a.htm')
end

Then('I can see the CLASS of the link') do
  expect(@test_site.home.a_link['class']).to eq('a')
end

Then('all mapped elements are present') do
  mapped_item_names =
    @test_site.dynamic.class.mapped_items.map(&:values).flatten.sort

  expect(@test_site.dynamic.elements_present.sort).to eq(mapped_item_names)
end

Then('not all mapped elements are present') do
  mapped_item_names =
    @test_site.dynamic.class.mapped_items.map(&:values).flatten

  expect(@test_site.dynamic.elements_present).not_to eq(mapped_item_names)
end

Then('the previously visible element is invisible') do
  expect(@test_site.vanishing.delayed).not_to be_visible
end

When('I remove the parent section of the element') do
  @test_site.vanishing.remove_container_button.click
end

Then('I can obtain the native property of an element') do
  expect(@test_site.home.header.native)
    .to be_a Selenium::WebDriver::Element
end

Then('I can obtain the native property of a section') do
  expect(@test_site.home.people.native).to be_a Selenium::WebDriver::Element
end
