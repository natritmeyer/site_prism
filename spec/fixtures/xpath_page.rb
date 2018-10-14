# frozen_string_literal: true

class XPathPage < SitePrism::Page
  include ItemStubs

  element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
  elements :bobs, '//a[@class="a"]//b[@class="b"]'
  element :dave, :xpath, '//w[@class="x"]//y[@class="z"]'
  element :success_msg, :xpath, '//span[@class="alert-success"]'
  elements :plural, '//[@class="many"]'
  section :section_xpath, '//span[@class="locator"]' do
    element :inner_element_one, '//[@class="one"]'
    element :inner_element_two, '//[@class="two"]'
  end
  sections :plural_sections, Blank, '//span[@class="locator"]'

  expected_elements :bob
end
