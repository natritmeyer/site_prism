# frozen_string_literal: true

module SitePrism
  # Generic SitePrism family of errors which specific errors are children of
  class SitePrismError < StandardError; end

  # Generic PageLoad family of errors inherit from this error
  class PageLoadError < SitePrismError; end

  # A page calls #load with no URL set
  class NoUrlForPageError < PageLoadError; end

  # A page calls #displayed? with no URL matcher set
  class NoUrlMatcherForPageError < PageLoadError; end

  # The URL matcher was not recognised as a Regex or String and as such
  # it couldn't be parsed by Addressable
  class InvalidUrlMatcherError < PageLoadError
    def message
      warn 'Templated port numbers are unsupported.'

      'Your URL and/or matcher could not be interpreted.'
    end
  end

  # A SitePrism defined DSL item was defined without a selector
  class InvalidElementError < SitePrismError
    def message
      "#{super} has been derived from an item with no selectors defined."
    end
  end

  # The condition that was being evaluated inside the block did not evaluate
  # to true within the time limit
  class TimeoutError < SitePrismError
    def message
      "Timed out after #{super}s."
    end
  end

  # These errors are not yet migrated and are fired from their source
  # They are raised when the meta-programmed method has not yielded true
  # in the prescribed time limit
  class ExistenceTimeoutError < TimeoutError; end
  class NonExistenceTimeoutError < TimeoutError; end
  class ElementVisibilityTimeoutError < TimeoutError; end
  class ElementInvisibilityTimeoutError < TimeoutError; end

  # A Block was passed to the method, which it cannot interpret
  class UnsupportedBlockError < SitePrismError
    def message
      warn 'section and iframe are the only items which can accept a block.'

      "#{super} does not accept blocks."
    end
  end

  # A Block was required, but not passed into the iframe at runtime
  class MissingBlockError < SitePrismError
    def message
      'You can only use iFrames in a block context - Please pass in a block.'
    end
  end

  # A page was loaded via #load - And then failed one of the load validations
  # that was either pre-defined or defined by the user
  class FailedLoadValidationError < PageLoadError
    def message
      if super == self.class.to_s
        'Failed to load - No reason specified.'
      else
        "Failed to load. Reason: #{super}"
      end
    end
  end

  # Legacy Error Code aliases for backwards compatibility
  NoUrlForPage                         = NoUrlForPageError
  NoUrlMatcherForPage                  = NoUrlMatcherForPageError
  InvalidUrlMatcher                    = InvalidUrlMatcherError
  NoSelectorForElement                 = InvalidElementError
  TimeoutException                     = TimeoutError
  TimeOutWaitingForExistenceError      = Class.new(StandardError) # To avoid message leaking
  TimeOutWaitingForNonExistenceError   = Class.new(StandardError) # To avoid message leaking
  TimeOutWaitingForElementVisibility   = Class.new(StandardError) # To avoid message leaking
  TimeOutWaitingForElementInvisibility = Class.new(StandardError) # To avoid message leaking
  UnsupportedBlock                     = UnsupportedBlockError
  BlockMissingError                    = MissingBlockError
  NotLoadedError                       = FailedLoadValidationError
end
