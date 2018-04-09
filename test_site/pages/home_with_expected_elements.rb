# frozen_string_literal: true

class TestHomePageWithExpectedElements < SitePrism::Page
  set_url '/home.htm'
  set_url_matcher(/home\.htm$/)

  # individual elements
  element :welcome_header, :xpath, '//h1'
  element :welcome_message, :xpath, '//span'
  element :go_button, :xpath, '//input'
  element :link_to_search_page, :xpath, '//p[2]/a'
  element :some_slow_element, :xpath, '//a[@class="slow"]'
  element :invisible_element, 'input.invisible'
  element :shy_element, 'input#will_become_visible'
  element :retiring_element, 'input#will_become_invisible'
  element :nonexistent_element, 'input#nonexistent'

  expected_elements :welcome_message, :go_button, :link_to_search_page
end
