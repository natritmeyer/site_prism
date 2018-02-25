class TestHomePageWithExcludedElements < SitePrism::Page
  set_url('/home_with_excluded_elements.htm')
  set_url_matcher(/home_with_excluded_elements\.htm$/)

  # individual elements
  element(:welcome_header, :xpath, '//h1')
  element(:welcome_message, :xpath, '//span')
  element(:go_button, :xpath, '//input')
  element(:nonexistent_element, 'input#nonexistent')

  def excluded_elements
    %w[nonexistent_element]
  end
end
