# frozen_string_literal: true

module SitePrism
  module ElementChecker
    def all_there?
      elements_to_check.all? { |element| send "has_#{element}?" }
    end

    private

    def elements_to_check
      elements = self.class.mapped_items
      if self.respond_to? :excluded_elements
        elements = elements.select { |el| !self.excluded_elements.include? el }
      end
      elements
    end
  end
end
