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
      root_element.visible?
    end

    def execute_script input
      Capybara.current_session.execute_script input
    end

    def evaluate_script input
      Capybara.current_session.evaluate_script input
    end

    private

    def find_first selector
      root_element.first selector
    end

    def find_all selector
      root_element.all selector
    end

    def element_exists? selector
      root_element.has_selector? selector
    end
  end
end

