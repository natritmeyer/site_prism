# frozen_string_literal: true

class Home < SitePrism::Page
  set_url '/home.htm'
  set_url_matcher(/home\.htm$/)

  # individual elements
  element :welcome_header, :xpath, '//h1'
  element :welcome_message, 'body > span'
  element :go_button, '[value="Go!"]'
  element :search_page_link, :xpath, '//p[2]/a'
  element :slow_element, :xpath, '//a[@class="slow"]'
  element :invisible, 'input.invisible'
  element :vanishing, 'input#will_become_invisible'
  element :removing_element, 'input#will_become_nonexistent'
  element :remove_container_button, 'input#remove_container'

  # element groups
  elements :removing_links, '#removing_link_div > a'
  elements :nonexistents, 'input#nonexistent'
  elements :rows, 'td'
  # note - actually only one of the below
  elements :slow_elements, :xpath, '//a[@class="slow"]'

  # elements that should not exist
  element :nonexistent_element, 'input#nonexistent'

  # individual sections
  section :people, People do
    element :headline_clone, 'h2'
  end
  section :container, Container, '#container'
  section :nonexistent_section, Blank, 'input#nonexistent'
  section :removing_section, Blank, 'input#will_become_nonexistent'
  section :slow_section, Blank, 'div.first.slow-section'

  # section groups
  sections :nonexistent_sections, Blank, 'input#nonexistent'
  sections :removing_sections, Blank, '#removing_link_div > a'
  sections :slow_sections, Blank, 'div.slow-section'

  # iframes
  iframe :id_iframe, Iframe, '#the_iframe'
  iframe :index_iframe, Iframe, 0
  iframe :named_iframe, Iframe, '[name="the_iframe"]'
  iframe :xpath_iframe, Iframe, :xpath, '//iframe[@name="the_iframe"]'

  section :section_for_iframe, '#section_for_iframe' do
    iframe :iframe_within_section, Iframe, 0
  end
end
