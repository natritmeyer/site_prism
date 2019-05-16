# frozen_string_literal: true

class CSSPage < SitePrism::Page
  element :element_one, 'a.b c.d'
  element :element_two, 'w.x y.z'
  element :element_three, 'span.alert-success'

  elements :elements_one, 'a.a b.b'
  elements :elements_two, '.many'

  section :section_one, CSSSection, 'span.locator'

  sections :sections_one, Blank, 'span.locator'

  iframe :iframe, CSSIFrame, '.iframe'

  expected_elements :element_one, :elements_one, :section_one, :sections_one
end
