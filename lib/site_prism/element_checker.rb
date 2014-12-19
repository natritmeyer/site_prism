module SitePrism
  module ElementChecker
    def all_there?
      Capybara.using_wait_time(0) do
        expected_elements.all? { |element| send "has_#{element}?" }
      end
    end

    private

    def expected_elements
      elements = self.class.mapped_items
      if self.respond_to?(:excluded_elements)
        elements = elements.select { |el| !excluded_elements.include? el }
      end
      elements
    end
  end
end
