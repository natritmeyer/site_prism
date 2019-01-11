# frozen_string_literal: true

class Home < SitePrism::Page
  set_url '/home.htm'
  set_url_matcher(/home\.htm$/)

  # individual elements
  element :header, :xpath, '//h1'
  element :welcome_message, 'body > span'
  element :go_button, '[value="Go!"]'
  element :a_link, '#link_div > a.a'
  element :nonexistent_element, 'input#nonexistent'

  # element groups
  elements :nonexistents, 'input#nonexistent'
  elements :list_of_people, '.person'

  # individual sections
  section :people, People do
    element :headline_clone, 'h2'
  end
  section :nonexistent_section, Blank, 'input#nonexistent'
  section :removing_section, Blank, 'input#will_become_nonexistent'
  section :vanishing_section, Blank, 'input#will_become_invisible'

  # section groups
  sections :nonexistent_sections, Blank, 'input#nonexistent'
  sections :slow_sections, Blank, 'div.slow-section'

  # iframes
  iframe :id_iframe, Iframe, '#the_iframe'
  iframe :index_iframe, Iframe, 0
  iframe :named_iframe, Iframe, '[name="the_iframe"]'
  iframe :xpath_iframe, Iframe, :xpath, '//iframe[@name="the_iframe"]'

  section :section_for_iframe, '#section_for_iframe' do
    iframe :iframe_within_section, Iframe, 0
  end

  expected_elements :header, :welcome_message
end
