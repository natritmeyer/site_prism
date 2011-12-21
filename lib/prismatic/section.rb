module Prismatic
  class Section < ElementContainer
    attr_reader :root_element_locator
  
    def initialize root_element_locator
      @root_element_locator = root_element_locator
    end
  end
end