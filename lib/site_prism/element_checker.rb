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
    # Note that #elements_to_check will check the hash of mapped_items
    #
    # When using the recursion parameter, one of two values is valid.
    #
    # Default: 'none' => Perform no recursion when calling #all_there?
    # Override: 'one' => Perform one recursive dive into all section/sections
    # items and call #all_there? on all of those items too.
    def all_there?(recursion: :none)
      if recursion == :none
        elements_to_check.all? { |name| there?(name) }
      elsif recursion == :one
        RecursionChecker.new(self, self.class.mapped_items(legacy: false)).all_there?
      else
        SitePrism.logger.debug("Input value '#{recursion}'. Valid values are :none or :one.")
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
