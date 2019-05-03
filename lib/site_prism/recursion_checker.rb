# frozen_string_literal: true

module SitePrism
  module RecursionChecker
    module_function
    # When using the recursion parameter, one of two values is valid.
    #
    # Default: 'none' => Perform no recursion when calling #all_there?
    # Override: 'one' => Perform one recursive dive into all section/sections
    # items and call #all_there? on all of those items too.

    def recursion
      @opts.fetch(:recursion)
    end

    def no_recursion?
      recursion == 'none'
    end

    def recursion?
      recursion == 'one'
    end

    # Return all expected element/elements/section/sections/iframe items
    def expected_item_map
      initial_map = self.class.mapped_items(legacy: false)

      [
        initial_map[:element].select { |name| _expected_items.include?(name) },
        initial_map[:elements].select { |name| _expected_items.include?(name) },
        initial_map[:section].select { |name| _expected_items.include?(name) },
        initial_map[:sections].select { |name| _expected_items.include?(name) },
        initial_map[:iframe].select { |name| _expected_items.include?(name) },
      ]
    end

    def all_there?(*opts)
      @opts = opts

      if no_recursion?
        elements_to_check.all? { |name| there?(name) }
      elsif recursion?
        regular_items_all_there = expected_item_map.all? { |name| there?(name) }
        return regular_items_all_there unless regular_items_all_there

        section_classes_to_check = expected_item_map[2].map { |name| self.send(name) }
        section_all_there = section_classes_to_check.all? { |instance| instance.all_there?(recursion: 'none') }
        return false unless section_all_there

        # Returning this final check here is fine, as the previous two checks must
        # have returned +true+ in order to hit this part of the method-call
        sections_classes_to_check = expected_item_map[3].map { |name| self.send(name) }.flatten
        sections_classes_to_check.all? { |instance| instance.all_there?(recursion: 'none') }
      else
        SitePrism.logger.error('Invalid recursion setting, Will not run #all_there?.')
      end
    end
  end
end
