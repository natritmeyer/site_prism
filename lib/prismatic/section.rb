module Prismatic
  class Section
    extend ElementContainer
    
    attr_reader :root_element_locator
  
    def initialize root_element
      @root_element = root_element
    end
    
    private
    
    def find_one locator
      @root_element.find locator
    end
    
    def find_all locator
      @root_element.all locator
    end
  end
end