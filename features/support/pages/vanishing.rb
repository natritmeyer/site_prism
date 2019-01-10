# frozen_string_literal: true

class Vanishing < SitePrism::Page
  set_url '/vanishing.htm'
  set_url_matcher(/vanishing\.htm$/)

  element :embedded, '#container .embedded_element'
  element :invisible, '.invisible'
  element :delayed, '#will_become_invisible'
  element :remove_container_button, 'input#remove_container'
  elements :submit_buttons, 'input[type="submit"]'
  elements :removed_elements, '.div_that_is_removed'
  section :delayed_section, Blank, '#will_become_invisible'
  sections :removed_sections, Blank, '.div_that_is_removed'

  # To test vanishing elements inside a section
  section :container, '#container' do
    elements :embedded, '.embedded_element'
  end
end
