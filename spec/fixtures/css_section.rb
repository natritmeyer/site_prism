# frozen_string_literal: true

class CSSSection < SitePrism::Page
  element :inner_element_one, '.one'
  element :inner_element_two, '.two'
  iframe :iframe, CSSIFrame, '.iframe'
end
