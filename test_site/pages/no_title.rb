class TestNoTitle < SitePrism::Page
  set_url "file://" + Dir.pwd + "/test_site/html/no_title.htm"

  element :element_without_selector
  elements :elements_without_selector
end

