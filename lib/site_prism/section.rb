module SitePrism
  class Section
    include Capybara::DSL
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
      Capybara.current_session.execute_script input
    end

    def evaluate_script input
      Capybara.current_session.evaluate_script input
    end

    private

    def find_one locator
      @root_element.find locator
    end

    def find_all locator
      @root_element.all locator
    end

    def element_exists? locator
      @root_element.has_selector? locator
    end

    def element_waiter locator
      Capybara.current_session.wait_until { element_exists? locator }
    end
  end
end

