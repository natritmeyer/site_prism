# frozen_string_literal: true

module SitePrism
  module ElementChecker
    # Runnable in the scope of any SitePrism::Page or Section.
    # Returns +true+ when "every item" that is being checked is
    # present within the current scope. See #elements_to_check
    # for how the definition of "every item" is derived.
    #
    # Example
    # @my_page.mapped_items
    # { element => :button_one, element => :button_two, section => :filters }
    # @my_page.all_there?
    # => true - If the three items above are all present
    #
    # Note that #elements_to_check will affect the hash of mapped_items
    #
    # When using the recursion parameter, one of two values is valid.
    #
    # Default: 'none' => Perform no recursion when calling #all_there?
    # Override: 'one' => Perform one recursive dive into all section/sections
    # items and call #all_there? on all of those items too.
    def all_there?(recursion: 'none')
      if recursion == 'none'
        elements_to_check.all? { |name| there?(name) }
      elsif recursion == 'one'
        # Generate the nested hash of all mapped items
        new_mapped_items = self.class.mapped_items(legacy: false)

        # Return all expected element/elements/section/sections/iframe items
        test_element = new_mapped_items[:element].select { |name| elements_to_check.include?(name) }
        test_elements = new_mapped_items[:elements].select { |name| elements_to_check.include?(name) }
        test_section = new_mapped_items[:section].select { |name| elements_to_check.include?(name) }
        test_sections = new_mapped_items[:sections].select { |name| elements_to_check.include?(name) }
        test_iframe = new_mapped_items[:iframe].select { |name| elements_to_check.include?(name) }

        regular_items_to_check = [test_element, test_elements, test_section, test_sections, test_iframe].flatten
        regular_items_all_there = regular_items_to_check.all? { |name| there?(name) }
        return regular_items_all_there unless regular_items_all_there

        section_classes_to_check = test_section.map { |name| send(name) }
        section_all_there = section_classes_to_check.all? do |instance|
          instance.all_there?(recursion: 'none')
        end
        return section_all_there unless section_all_there

        sections_classes_to_check = test_sections.map { |name| send(name) }.flatten
        sections_all_there = sections_classes_to_check.all? do |instance|
          instance.all_there?(recursion: 'none')
        end
        # Returning this final check here is fine, as the previous two checks must
        # have returned +true+ in order to hit this part of the method-call
        sections_all_there
      else
        SitePrism.logger.error('Invalid recursion setting, Will not run #all_there?.')
      end
    end

    def elements_present
      _mapped_items.select { |name| there?(name) }
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
      self.class.mapped_items(legacy: false).values.flatten.uniq
    end

    def _expected_items
      self.class.expected_items
    end

    def there?(name)
      send("has_#{name}?")
    end
  end
end
