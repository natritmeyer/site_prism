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

    def find_first *q
      root_element.first *q
    end

    def find_all *q
      root_element.all *q
    end

    def element_exists? *q
      root_element.has_selector? *q
    end
  end
end

