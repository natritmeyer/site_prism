# frozen_string_literal: true

class TestHomePageWithExpectedElements < SitePrism::Page
  set_url '/home.htm'
  set_url_matcher(/home\.htm$/)

  element :welcome_header, :xpath, '//h1'
  element :welcome_message, :xpath, '//span'
  element :nonexistent_element, 'input#nonexistent'

  expected_elements :welcome_header, :welcome_message
end
