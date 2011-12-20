class TestHomePage < Prismatic::Page
  set_url "/home.htm"
  set_url_matcher /home\.htm$/
  
  element :welcome_header, 'h1'
  element :welcome_message, 'span'
  element :go_button, 'input'
  element :link_to_search_page, 'a'
  
  #elements that should not exist
  element :squirrel, 'squirrel.nutz'
  element :other_thingy, 'other.thingy'
end