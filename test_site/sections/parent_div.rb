# frozen_string_literal: true

class ParentDiv < SitePrism::Section
  element :slow_element, 'a.slow'
  section :child, Child, '.child-div'
end
