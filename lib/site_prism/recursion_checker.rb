# frozen_string_literal: true

module SitePrism
  class RecursionChecker
    def initialize(instance, mapped_items)
      @instance = instance
      @mapped_items = mapped_items
    end

    # module_function

    # When using the recursion parameter, one of two values is valid.
    #
    # Default: 'none' => Perform no recursion when calling #all_there?
    # Override: 'one' => Perform one recursive dive into all section/sections
    # items and call #all_there? on all of those items too.

    # Return all expected element/elements/section/sections/iframe items
    def all_there?
      regular_items_all_there = expected_item_map.flatten.all? { |name| there?(name) }
      return false unless regular_items_all_there

      section_all_there =
        section_classes_to_check.all? { |instance| instance.all_there?(recursion: 'none') }
      return false unless section_all_there

      # Returning this final check here is fine, as the previous two checks must
      # have returned +true+ in order to hit this part of the method-call
      sections_classes_to_check.all? { |instance| instance.all_there?(recursion: 'none') }
    end

    def expected_item_map
      initial_map = @mapped_items

      [
        expected(initial_map, :element),
        expected(initial_map, :elements),
        expected(initial_map, :section),
        expected(initial_map, :sections),
        expected(initial_map, :iframe),
      ]
    end

    def expected(map, type)
      map[type].select { |name| elements_to_check.include?(name) }
    end

    def section_classes_to_check
      expected_item_map[2].map { |name| @instance.send(name) }
    end

    def sections_classes_to_check
      expected_item_map[3].map { |name| @instance.send(name) }.flatten
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
      @mapped_items.values.flatten.uniq
    end

    def _expected_items
      @instance.class.expected_items
    end

    def there?(name)
      @instance.send("has_#{name}?")
    end
  end
end
