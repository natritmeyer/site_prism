# frozen_string_literal: true

class Parent < SitePrism::Section
  element :slow_element, 'a.slow'
  section :child_section, Child, '.child-div'
end
