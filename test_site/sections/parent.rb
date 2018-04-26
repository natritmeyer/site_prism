# frozen_string_literal: true

class Parent < SitePrism::Section
  element :slow_section_element, 'a.slow'
  element :removing_section_element, '.removing-element'
  section :child_section, Child, '.child-div'
end
