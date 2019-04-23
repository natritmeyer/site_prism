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
    # When using the recursion parameter, one of three values is valid.
    #
    # Default: 'none' => Perform no recursion when calling #all_there?
    # Override: 'one' => Perform one recursive dive into all section/sections
    # items and call #all_there? on all of those items too.
    def all_there?(recursion: 'none')
      if recursion == 'none'
        elements_to_check.all? { |item_name| there?(item_name) }
      elsif recursion == 'one'
        # TODO: Make this work with expected_items! (LH) - Just first five lines below
        _element = self.class.mapped_items(legacy: false)[:element]
        _elements = self.class.mapped_items(legacy: false)[:elements]
        _section = self.class.mapped_items(legacy: false)[:section]
        _sections = self.class.mapped_items(legacy: false)[:sections]
        _iframe = self.class.mapped_items(legacy: false)[:iframe]

        test_element = _element.select { |item_name| _expected_items.include?(item_name) }
        test_elements = _elements.select { |item_name| _expected_items.include?(item_name) }
        test_section = _section.select { |item_name| _expected_items.include?(item_name) }
        test_sections = _sections.select { |item_name| _expected_items.include?(item_name) }
        test_iframe = _iframe.select { |item_name| _expected_items.include?(item_name) }

        regular_items_to_check = _element + _elements + _section + _sections + _iframe
        regular_items_all_there = regular_items_to_check.all? { |item_name| there?(item_name) }
        return regular_items_all_there unless regular_items_all_there

        section_classes_to_check = _section.map { |section_name| self.send(section_name) }
        section_all_there = section_classes_to_check.all? do |instance|
          instance.all_there?(recursion: 'none')
        end
        return section_all_there unless section_all_there

        sections_classes_to_check = _sections.map { |section_name| self.send(section_name) }.flatten
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
      _mapped_items.select { |item_name| there?(item_name) }
    end

    private

    # If the page or section has expected_items set, return expected_items that are mapped
    # otherwise just return the list of all mapped_items
    def elements_to_check
      if _expected_items
        SitePrism.logger.debug('Expected Items has been set.')
        _mapped_items.select { |item_name| _expected_items.include?(item_name) }
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

    def there?(item_name)
      send("has_#{item_name}?")
    end
  end
end
