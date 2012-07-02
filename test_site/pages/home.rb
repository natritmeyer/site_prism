class TestHomePage < SitePrism::Page
  set_url "/home.htm"
  set_url_matcher /home\.htm$/

  #individual elements
  element :welcome_header, 'h1'
  element :welcome_message, 'span'
  element :go_button, 'input'
  element :link_to_search_page, 'a'
  element :some_slow_element, 'a.slow'

  #element groups
  elements :lots_of_links, 'td a'

  #elements that should not exist
  element :squirrel, 'squirrel.nutz'
  element :other_thingy, 'other.thingy'

  #sections
  section :people, People, '.people'

  #iframes
  iframe :my_iframe, MyIframe, '#the_iframe'
end

