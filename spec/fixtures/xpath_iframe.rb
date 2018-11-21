# frozen_string_literal: true

class XPathIFrame < SitePrism::Page
  element :element_one, :xpath, '//[@class="some_element"]'
end
