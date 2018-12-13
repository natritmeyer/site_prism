# frozen_string_literal: true

module SitePrism
  module ElementChecker
    def all_there?
      elements_to_check.all? { |item_name| there?(item_name) }
    end

    def elements_present
      mapped_items.select { |item_name| there?(item_name) }
    end

    private

    def elements_to_check
      if expected_items
        SitePrism.logger.debug('Expected Items has been set.')
        mapped_items.select { |item_name| expected_items.include?(item_name) }
      else
        mapped_items
      end
    end

    def mapped_items
      mapped_items_list.map(&:values).flatten
    end

    def mapped_items_list
      self.class.mapped_items.uniq
    end

    def expected_items
      self.class.expected_items
    end

    def there?(item_name)
      send("has_#{item_name}?")
    end
  end
end
