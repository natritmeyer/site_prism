# frozen_string_literal: true

class XPathPage < SitePrism::Page
  element :element_one, :xpath, '//a[@class="b"]//c[@class="d"]'
  element :element_two, :xpath, '//w[@class="x"]//y[@class="z"]'
  element :element_three, :xpath, '//span[@class="alert-success"]'

  elements :elements_one, :xpath, '//a[@class="a"]//b[@class="b"]'
  elements :elements_two, :xpath, '//*[@class="many"]'

  section :section_one, :xpath, '//span[@class="locator"]' do
    element :inner_element_one, :xpath, '//*[@class="one"]'
    element :inner_element_two, :xpath, '//*[@class="two"]'
    iframe :iframe, XPathIFrame, :xpath, '//*[@class="iframe"]'
  end

  sections :sections_one, Blank, :xpath, '//span[@class="locator"]'

  iframe :iframe, XPathIFrame, :xpath, '//*[@class="iframe"]'

  expected_elements :element_one
end
