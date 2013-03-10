class TestHomePage < SitePrism::Page
  set_url "/home.htm"
  set_url_matcher /home\.htm$/

  #individual elements
  element :welcome_header, :xpath, '//h1'
  element :welcome_message, :xpath, '//span'
  element :go_button, :xpath, '//input'
  element :link_to_search_page, :xpath, '//a'
  element :some_slow_element, :xpath, '//a[@class="slow"]'
  element :invisible_element, 'input.invisible'
  element :shy_element, 'input#will_become_visible'
  element :retiring_element, 'input#will_become_invisible'
  element :nonexistent_element, 'input#nonexistent'
  element :remove_container_with_element_btn, 'input#remove_container_with_element'

  #element groups
  elements :lots_of_links, :xpath, '//td//a'

  #elements that should not exist
  element :squirrel, 'squirrel.nutz'
  element :other_thingy, 'other.thingy'

  #sections
  section :people, People, '.people'
  section :container_with_element, ContainerWithElement, '#container_with_element'

  #iframes
  iframe :my_iframe, MyIframe, '#the_iframe'
end

