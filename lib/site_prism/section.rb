module SitePrism
  class Section
    include ElementChecker
    extend ElementContainer

    attr_reader :root_element

    def initialize root_element
      @root_element = root_element
    end

    def visible?
      @root_element.visible?
    end

    def execute_script input

    end

    def evaluate_script input

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

    # Section specific element waiter
    def element_waiter locator
      wait_until { element_exists? locator }
    end
  end
end

