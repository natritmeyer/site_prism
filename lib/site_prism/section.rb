module SitePrism
  class Section
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    attr_reader :root_element, :parent

    def initialize root_element, parent
      @root_element, @parent = root_element, parent
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

    def current_page
      page = self.parent

      until page.is_a?(SitePrism::Page)
        page = page.parent
      end

      page
    end

    private

    def find_first *find_args
      root_element.first *find_args
    end

    def find_all *find_args
      root_element.all *find_args
    end

    def element_exists? *find_args
      root_element.has_selector? *find_args
    end
  end
end

