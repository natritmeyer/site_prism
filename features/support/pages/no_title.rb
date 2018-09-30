# frozen_string_literal: true

class NoTitle < SitePrism::Page
  set_url '/no_title.htm'
  set_url_matcher(/no_title\.htm$/)

  element :element_without_selector
  elements :elements_without_selector
  element :message, 'p'
  element :missing_message, 'br'

  expected_elements :message, :missing_message
end
