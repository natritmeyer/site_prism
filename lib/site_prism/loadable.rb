# frozen_string_literal: true

module SitePrism
  module Loadable
    module ClassMethods
      # The list of load_validations.
      # They will be executed in the order they are defined.
      #
      # @return [Array]
      def load_validations
        if superclass.respond_to?(:load_validations)
          superclass.load_validations + _load_validations
        else
          _load_validations
        end
      end

      # Appends a load validation block to the page class.
      #
      # When `loaded?` is called, these blocks are instance_eval'd
      # against the current page instance.
      # This allows users to wait for specific events to occur on
      # the page or certain elements to be loaded before performing
      # any actions on the page.
      #
      # @param block [&block] A block which returns true if the page
      # loaded successfully, or false if it did not.
      # This block can contain up to 2 elements in an array
      # The first is the physical validation test to be truthily evaluated.
      #
      # If this does not pass, then the 2nd item (if defined), is output
      # as an error message to the +FailedLoadValidationError+ that is thrown
      def load_validation(&block)
        _load_validations << block
      end

      private

      def _load_validations
        @_load_validations ||= []
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # In certain circumstances, we cache that the page has already
    # been confirmed to be loaded so that actions which
    # call `loaded?` a second time do not need to perform
    # the load_validation queries against the page a second time.
    attr_accessor :loaded, :load_error

    # Executes the given block after the page is loaded.
    #
    # The loadable object instance is yielded into the block.
    def when_loaded
      # Get original loaded value, in case we are nested
      # inside another when_loaded block.
      previously_loaded = loaded

      # Within the block, check (and cache) loaded?, to see whether the
      # page has indeed loaded according to the rules defined by the user.
      self.loaded = loaded?

      # If the page hasn't loaded. Then crash and return the error message.
      # If one isn't defined, just return the Error code.
      raise SitePrism::FailedLoadValidationError, load_error unless loaded

      # Return the yield value of the block if one was supplied.
      yield self if block_given?
    ensure
      self.loaded = previously_loaded
    end

    # Check if the page is loaded.
    #
    # On failure, if an error was reported by a failing validation,
    # it will be available via the `load_error` accessor.
    #
    # @return [Boolean] True if the page loaded successfully; otherwise false.
    def loaded?
      self.load_error = nil

      return true if loaded

      load_validations_pass?
    end

    private

    # If any load validations from page subclasses returns false,
    # immediately return false.
    def load_validations_pass?
      self.class.load_validations.all? do |validation|
        passed, message = instance_eval(&validation)

        self.load_error = message if message && !passed
        passed
      end
    end
  end
end
