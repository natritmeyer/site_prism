# frozen_string_literal: true

module SitePrism
  module ElementChecker
    def all_there?
      elements_to_check.all? { |element| present?(element) }
    end

    def elements_present
      mapped_items.select { |item_name| present?(item_name) }
    end

    private

    def elements_to_check
      if self.class.expected_items
        mapped_items.select do |el|
          self.class.expected_items.include?(el)
        end
      else
        mapped_items
      end
    end

    def mapped_items
      self.class.mapped_items.uniq
    end

    def present?(element)
      send("has_#{element}?")
    end
  end
end
