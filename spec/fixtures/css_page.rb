# frozen_string_literal: true

class CSSPage < SitePrism::Page
  include ItemStubs

  element :bob, 'a.b c.d'
  elements :bobs, 'a.a b.b'
  element :dave, 'w.x y.z'
  element :success_msg, 'span.alert-success'
  elements :plural, '.many'
  section :section_xpath, 'span.locator' do
    element :inner_element_one, '.one'
    element :inner_element_two, '.two'
  end
  sections :plural_sections, Blank, 'span.locator'

  expected_elements :bob
end
