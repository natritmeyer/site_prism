# frozen_string_literal: true

class XPathSection < SitePrism::Section
  element :inner_element_one, :xpath, '//*[@class="one"]'
  element :inner_element_two, :xpath, '//*[@class="two"]'
  iframe :iframe, XPathIFrame, :xpath, '//*[@class="iframe"]'
end
