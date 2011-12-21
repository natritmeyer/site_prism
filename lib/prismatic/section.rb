module Prismatic
  class Section
    extend ElementContainer
    
    def initialize root_element
      @root_element = root_element
    end
    
    private
    
    # Section specific element finder
    def find_one locator
      @root_element.find locator
    end
    
    # Section specific elements finder
    def find_all locator
      @root_element.all locator
    end
  end
end