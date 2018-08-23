# frozen_string_literal: true

Then('the page does not have element') do
  expect(@test_site.home.has_no_nonexistent_element?).to be true

  expect(@test_site.home).to have_no_nonexistent_element
end

Then('I can see the welcome header') do
  expect(@test_site.home).to have_welcome_header

  expect(@test_site.home.welcome_header.text).to eq('Welcome')
end

Then('I can see a header using a capybara text query') do
  expect(@test_site.home).to have_welcome_headers(text: 'Sub-Heading 2')
end

Then('I can see a row using a capybara class query') do
  expect(@test_site.home).to have_rows(class: 'link_c')
end

Then('I can see the first row') do
  expect(@test_site.home).to have_rows

  expect(@test_site.home.rows.first.text).to eq('a')
end

Then('the welcome header is not matched with invalid text') do
  expect(@test_site.home).to have_no_welcome_header(text: "This Doesn't Match!")
end

Then('I can see the welcome message') do
  expect(@test_site.home).to have_welcome_message

  expect(@test_site.home.welcome_message.text)
    .to eq('This is the home page, there is some stuff on it')
end

Then('I can see a message using a capybara text query') do
  sample_text = 'This is the home page, there is some stuff on it'

  expect(@test_site.home).to have_welcome_messages(text: sample_text)
end

Then('I can see the the HREF of the link') do
  expect(@test_site.home).to have_link_to_search_page

  expect(@test_site.home.link_to_search_page['href']).to include('search.htm')
end

Then('I can see the CLASS of the link') do
  expect(@test_site.home.link_to_search_page['class'])
    .to eq('link link--undefined')
end

Then('not all expected elements are present') do
  expect(@test_site.home).not_to be_all_there
end

Then('all elements marked as expected are present') do
  expect(@test_site.home_with_expected_elements).to be_all_there
end

Then('all mapped elements are present') do
  expect(@test_site.dynamic_page.elements_present)
    .to eq(@test_site.dynamic_page.class.mapped_items)
end

Then('not all mapped elements are present') do
  expect(@test_site.home.elements_present)
    .not_to eq(@test_site.home.class.mapped_items)
end

Then('the previously invisible element is visible') do
  expect(@test_site.home).to have_shy_element
end

Then('the previously visible element is invisible') do
  expect(@test_site.home.retiring_element).not_to be_visible
end

Then('I am not made to wait to check a nonexistent element for invisibility') do
  start = Time.new
  @test_site.home.wait_until_nonexistent_element_invisible(10)

  expect(Time.new - start).to be < 1
end

When('I remove the parent section of the element') do
  @test_site.home.remove_container_with_element_btn.click
end

Then('an error is thrown when waiting for an element in a vanishing section') do
  expect do
    @test_site.home.container_with_element.wait_until_embedded_element_invisible
  end.to raise_error(Capybara::ElementNotFound)
end

Then('I can obtain the native property of an element') do
  expect(@test_site.home.welcome_header.native)
    .to be_a Selenium::WebDriver::Element
end

Then('I can obtain the native property of a section') do
  expect(@test_site.home.people.native).to be_a Selenium::WebDriver::Element
end
