# frozen_string_literal: true

module SitePrism
  class RecursionChecker
    attr_reader :instance
    private :instance

    def initialize(instance)
      @instance = instance
    end

    def all_there?
      regular_items_all_there = expected_item_map.flatten.all? { |name| there?(name) }
      return false unless regular_items_all_there

      section_all_there =
        section_classes_to_check.all?(&:all_there?)
      return false unless section_all_there

      # Returning this final check here is fine, as the previous two checks must
      # have returned +true+ in order to hit this part of the method-call
      sections_classes_to_check.all?(&:all_there?)
    end

    def expected_item_map
      [
        expected(mapped_items, :element),
        expected(mapped_items, :elements),
        expected(mapped_items, :section),
        expected(mapped_items, :sections),
        expected(mapped_items, :iframe),
      ]
    end

    def expected(_map, type)
      mapped_items[type].select { |name| elements_to_check.include?(name) }
    end

    def section_classes_to_check
      expected_item_map[2].map { |name| instance.send(name) }
    end

    def sections_classes_to_check
      expected_item_map[3].map { |name| instance.send(name) }.flatten
    end

    private

    # If the page or section has expected_items set, return expected_items that are mapped
    # otherwise just return the list of all mapped_items
    def elements_to_check
      if _expected_items
        SitePrism.logger.debug('Expected Items has been set.')
        _mapped_items.select { |name| _expected_items.include?(name) }
      else
        _mapped_items
      end
    end

    def _mapped_items
      mapped_items.values.flatten.uniq
    end

    def _expected_items
      instance.class.expected_items
    end

    def there?(name)
      instance.send("has_#{name}?")
    end

    def mapped_items
      @mapped_items ||= instance.class.mapped_items(legacy: false)
    end
  end
end
