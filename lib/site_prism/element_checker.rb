# frozen_string_literal: true

module SitePrism
  module ElementChecker
    def all_there?
      elements_to_check.all? { |element| send "has_#{element}?" }
    end

    private

    def elements_to_check
      elements = self.class.mapped_items
      elements = elements.reject { |el| excluded_elements.include?(el) } if respond_to?(:excluded_elements)
      elements
    end
  end
end
