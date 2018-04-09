# frozen_string_literal: true

Then(/^I can see an expected bit of the html$/) do
  expect(@test_site.home.html).to include('<span class="welcome">This is the home page')
end

Then(/^I can see an expected bit of text$/) do
  expect(@test_site.home.text).to include('This is the home page, there is some stuff on it')
end

Then(/^I can see the expected url$/) do
  expect(@test_site.home.current_url).to include('test_site/html/home.htm')
end

Then(/^I can see that the page is not secure$/) do
  expect(@test_site.home).not_to be_secure
end

Then(/^I can get the page title$/) do
  expect(@test_site.home.title).to eq('Home Page')
end

Then(/^the page has no title$/) do
  expect(@test_site.no_title.title).to eq('')
end
