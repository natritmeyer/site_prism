# frozen_string_literal: true

class Vanishing < SitePrism::Page
  set_url '/vanishing.htm'
  set_url_matcher(/vanishing\.htm$/)

  element :embedded, '#container .embedded_element'
  elements :submit_buttons, 'input[type="submit"]'
  section :container, Blank, '#container'
  sections :divs, Blank, '.div_that_is_removed'

  # To test vanishing elements inside a section
  section :container, '#container' do
    elements :embedded, '.embedded_element'
  end
end
