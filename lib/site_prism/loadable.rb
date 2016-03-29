module SitePrism
  module Loadable
    module ClassMethods
      # The list of load_validations.  They will be executed in the order they are defined.
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
      # When `loaded?` is called, these blocks are instance_eval'd against the current page
      # instance.  This allows users to wait for specific events to occur on the page or certain elements
      # to be loaded before performing any actions on the page.
      #
      # @param block [&block] A block which returns true if the page loaded successfully, or false if it did not.
      def load_validation(&block)
        _load_validations << block
      end

      def _load_validations
        @_load_validations ||= []
      end
      private :_load_validations
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # In certain circumstances, we cache that the page has already been confirmed to be loaded so that actions which
    # call `loaded?` a second time do not need to perform the load_validation queries against the page a second time.
    attr_accessor :loaded, :load_error

    # Executes the given block after the page is loaded.
    #
    # The loadable object instance is yielded into the block.
    #
    # @param block [&block] The block to be executed once the page has finished loading.
    def when_loaded(&_block)
      previously_loaded = loaded # Get original loaded value, in case we are nested inside another when_loaded block.
      raise(ArgumentError, 'A block was expected, but none received.') unless block_given?

      # Within the block, cache loaded? to optimize performance.
      self.loaded = loaded?
      unless loaded
        message = "Failed to load because: #{load_error || 'no reason given'}"
        raise(::SitePrism::NotLoadedError, message)
      end

      yield self
    ensure
      self.loaded = previously_loaded
    end

    # Check if the page is loaded.
    #
    # On failure, if an error was reported by a failing validation, it will be available via the `load_error` accessor.
    #
    # @return [Boolean] True if the page loaded successfully; otherwise false.
    def loaded?
      self.load_error = nil

      return true if loaded

      load_validations_pass?
    end

    # If any load validations from page subclasses returns false, immediately return false.
    def load_validations_pass?
      self.class.load_validations.all? do |validation|
        passed, message = instance_eval(&validation)

        self.load_error = message if message && !passed
        passed
      end
    end
    private :load_validations_pass?
  end
end
