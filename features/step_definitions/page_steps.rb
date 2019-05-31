# frozen_string_literal: true

Then('I can see an expected bit of the html') do
  expect(@test_site.home.html)
    .to include('<span class="welcome">This is the home page')
end

Then('I can see an expected bit of text') do
  expect(@test_site.home.text)
    .to include('This is the home page, there is some stuff on it')
end

Then('I can see the expected url') do
  expect(@test_site.home.current_url).to include('test_site/home.htm')
end

Then('I can see that the page is not secure') do
  expect(@test_site.home).not_to be_secure
end

Then('I can get the page title') do
  expect(@test_site.home.title).to eq('Home Page')
end

Then('the page has no title') do
  expect(@test_site.no_title.title).to eq('')
end

When('I execute some javascript on the page to set a value') do
  @test_site.nested_sections.first_search_result = 'wibble'
end

Then('I can evaluate some javascript on the page to get the value') do
  expect(@test_site.nested_sections.first_search_result).to eq('wibble')
end

Then('not all expected elements are present') do
  expect(@test_site.no_title).not_to be_all_there
end

Then('all elements marked as expected are present') do
  expect(@test_site.home).to be_all_there
end

Then('not all elements are present') do
  expect(@test_site.slow).not_to be_all_there
end

Then('all elements are present') do
  expect(@test_site.nested_sections).to be_all_there
end

Then('all elements and first-generation descendants are present') do
  expect(@test_site.dynamic).to be_all_there(recursion: :one)
end

Then('all elements and first-generation descendants are not present') do
  expect(@test_site.nested_sections).not_to be_all_there(recursion: :one)
end
