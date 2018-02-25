class TestHomePageWithExcludedElements < SitePrism::Page
  set_url '/home_with_excluded_elements.htm'
  set_url_matcher(/home_with_excluded_elements\.htm$/)

  # individual elements
  element :welcome_header, :xpath, '//h1'
  element :welcome_message, :xpath, '//span'
  element :go_button, :xpath, '//input'
  element :nonexistent_element, 'input#nonexistent'
  element :another_nonexistent_element, 'input#nothere'

  excluded_elements :nonexistent_element, :another_nonexistent_element
end
