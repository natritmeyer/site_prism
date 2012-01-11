module SitePrism
  class Section
    extend ElementContainer
    
    def initialize root_element
      @root_element = root_element
    end

    def visible?
      @root_element.visible?
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

    # Section specific element existence check
    def element_exists? locator
      @root_element.has_selector? locator
    end
  end
end
