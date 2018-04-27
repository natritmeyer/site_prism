# frozen_string_literal: true

Then(/^the page does not have element$/) do
  expect(@test_site.home.has_no_nonexistent_element?).to be true

  expect(@test_site.home).to have_no_nonexistent_element
end

Then(/^the page does not have a group of elements$/) do
  expect(@test_site.home.has_no_nonexistent_elements?).to be true

  expect(@test_site.home).to have_no_nonexistent_elements
end

Then(/^I can see the welcome header$/) do
  expect(@test_site.home).to have_welcome_header

  expect(@test_site.home.welcome_header.text).to eq('Welcome')
end

Then(/^I can see a header using a capybara text query$/) do
  expect(@test_site.home).to have_welcome_headers(text: 'Sub-Heading 2')
end

Then(/^I can see a row using a capybara class query$/) do
  expect(@test_site.home).to have_rows(class: 'link_c')
end

Then(/^I can see the first row$/) do
  expect(@test_site.home).to have_rows

  expect(@test_site.home.rows.first.text).to eq('a')
end

Then(/^the welcome header is not matched with invalid text$/) do
  expect(@test_site.home).to have_no_welcome_header(text: "This Doesn't Match!")
end

Then(/^I can see the welcome message$/) do
  expect(@test_site.home).to have_welcome_message

  expect(@test_site.home.welcome_message.text).to eq('This is the home page, there is some stuff on it')
end

Then(/^I can see a message using a capybara text query$/) do
  expect(@test_site.home).to have_welcome_messages(text: 'This is the home page, there is some stuff on it')
end

Then(/^I can see the go button$/) do
  expect(@test_site.home).to have_go_button
end

Then(/^I can see the the HREF of the link$/) do
  expect(@test_site.home).to have_link_to_search_page

  expect(@test_site.home.link_to_search_page['href']).to include('search.htm')
end

Then(/^I can see the CLASS of the link$/) do
  expect(@test_site.home.link_to_search_page['class']).to eq('link link--undefined')
end

Then(/^I can get the text values for the group of links$/) do
  expect(@test_site.home.lots_of_links.map(&:text)).to eq(%w[a b c])
end

Then(/^not all expected elements are present$/) do
  expect(@test_site.home).not_to be_all_there
end

Then(/^all elements marked as expected are present$/) do
  expect(@test_site.home_with_expected_elements).to be_all_there
end

Then(/^an exception is raised when I try to deal with an element with no selector$/) do
  expect { @test_site.no_title.has_element_without_selector? }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.element_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.wait_for_element_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
end

Then(/^an exception is raised when I try to deal with elements with no selector$/) do
  expect { @test_site.no_title.has_elements_without_selector? }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.elements_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
  expect { @test_site.no_title.wait_for_elements_without_selector }
    .to raise_error(SitePrism::NoSelectorForElement)
end

When(/^I wait until a particular element is visible$/) do
  @test_site.home.wait_until_some_slow_element_visible
end

When(/^I wait for a specific amount of time until a particular element is visible$/) do
  @test_site.home.wait_until_shy_element_visible(5)
end

Then(/^the previously invisible element is visible$/) do
  expect(@test_site.home).to have_shy_element
end

Then(/^I get a timeout error when I wait for an element that never appears$/) do
  expect { @test_site.home.wait_until_invisible_element_visible(1) }
    .to raise_error(SitePrism::TimeOutWaitingForElementVisibility)
end

When(/^I wait for an element to become invisible$/) do
  @test_site.home.wait_until_retiring_element_invisible
end

Then(/^the previously visible element is invisible$/) do
  expect(@test_site.home.retiring_element).not_to be_visible
end

When(/^I wait for a specific amount of time until a particular element is invisible$/) do
  @test_site.home.wait_until_retiring_element_invisible(5)
end

Then(/^I get a timeout error when I wait for an element that never disappears$/) do
  expect { @test_site.home.wait_until_welcome_header_invisible(1) }
    .to raise_error(SitePrism::TimeOutWaitingForElementInvisibility)
end

Then(/^I do not wait for an nonexistent element when checking for invisibility$/) do
  start = Time.new
  @test_site.home.wait_until_nonexistent_element_invisible(10)

  expect(Time.new - start).to be < 1
end

When(/^I remove the parent section of the element$/) do
  @test_site.home.remove_container_with_element_btn.click
end

Then(/^I receive an error when a section with the element I am waiting for is removed$/) do
  expect { @test_site.home.container_with_element.wait_until_embedded_element_invisible }
    .to raise_error(Capybara::ElementNotFound)
end

When(/^I wait a variable time for elements to appear$/) do
  @test_site.home.wait_for_lots_of_links
  @test_site.home.wait_for_lots_of_links(0.1)
end

When(/^I wait a variable time for elements to disappear$/) do
  @test_site.home.wait_for_no_removing_links
  @test_site.home.wait_for_no_removing_links(0.1)
end

Then(/^I can wait a variable time and pass specific parameters$/) do
  @test_site.home.wait_for_lots_of_links(0.1, count: 2)
  Capybara.using_wait_time 0.3 do
    # intentionally wait and pass nil to force this to cycle
    expect(@test_site.home.wait_for_lots_of_links(nil, count: 198_108_14)).to be false
  end
end

Then(/^I can wait a variable time for elements to disappear and pass specific parameters$/) do
  expect(@test_site.home.wait_for_no_removing_links(0.1, text: 'wibble')).to be true
end

Then(/^I can obtain the native property of an element$/) do
  expect(@test_site.home.welcome_header.native).to be_a Selenium::WebDriver::Element
end

Then(/^I can obtain the native property of a section$/) do
  expect(@test_site.home.people.native).to be_a Selenium::WebDriver::Element
end
