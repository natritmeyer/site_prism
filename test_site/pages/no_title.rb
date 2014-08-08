class TestNoTitle < SitePrism::Page
  set_url '/no_title.htm'

  element :element_without_selector
  elements :elements_without_selector
end
