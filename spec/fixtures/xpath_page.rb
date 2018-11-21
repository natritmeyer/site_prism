# frozen_string_literal: true

# TODO: Definition of iFrame here is in css because of a bug

class XPathPage < SitePrism::Page
  include ItemStubs

  element :element_one, '//a[@class="b"]//c[@class="d"]'
  element :element_two, '//w[@class="x"]//y[@class="z"]'
  element :element_three, '//span[@class="alert-success"]'

  elements :elements_one, '//a[@class="a"]//b[@class="b"]'
  elements :elements_two, '//[@class="many"]'

  section :section_one, '//span[@class="locator"]' do
    element :inner_element_one, '//[@class="one"]'
    element :inner_element_two, '//[@class="two"]'
    iframe :iframe, CSSIFrame, '.iframe'
  end

  sections :sections_one, Blank, '//span[@class="locator"]'

  iframe :iframe, CSSIFrame, '.iframe'

  expected_elements :element_one
end
