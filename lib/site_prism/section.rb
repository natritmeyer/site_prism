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

    def find_first *find_args
      root_element.first *find_args
    end

    def find_all *find_args
      root_element.all *find_args
    end

    def element_exists? *find_args
      unless root_element.nil?
        root_element.has_selector? *find_args
      end
    end
  end
end

