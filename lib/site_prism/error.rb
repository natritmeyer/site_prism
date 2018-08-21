# frozen_string_literal: true

module SitePrism
  # Generic SitePrism family of errors which specific errors are children of
  class SitePrismError < StandardError; end

  # Generic PageLoad family of errors inherit from this error
  class PageLoadError < SitePrismError; end

  # A page calls #load with no URL set
  # Formerly known as `NoUrlForPage`
  class NoUrlForPageError < PageLoadError; end

  # A page calls #displayed? with no URL matcher set
  # Formerly known as `NoUrlMatcherForPage`
  class NoUrlMatcherForPageError < PageLoadError; end

  # The URL matcher was not recognised as a Regex or String and as such
  # it couldn't be parsed by Addressable
  # Formerly known as `InvalidUrlMatcher`
  class InvalidUrlMatcherError < PageLoadError
    def message
      warn 'Templated port numbers are unsupported.'

      'Your URL and/or matcher could not be interpreted.'
    end
  end

  # A SitePrism defined DSL item was defined without a selector
  # Formerly known as `NoSelectorForElement`
  class InvalidElementError < SitePrismError
    def message
      "#{super} has been derived from an item with no selectors defined."
    end
  end

  # The condition that was being evaluated inside the block did not evaluate
  # to true within the time limit
  # Formerly known as `TimeoutException`
  class TimeoutError < SitePrismError; end

  # These errors are not yet migrated and are fired from their source
  # They are raised when the meta-programmed method has not yielded true
  # in the prescribed time limit
  # Formerly known as `TimeOutWaitingForExistenceError`,
  # `TimeOutWaitingForNonExistenceError`
  # `TimeOutWaitingForElementVisibility` and
  # `TimeOutWaitingForElementInvisibility` respectively

  class ExistenceTimeoutError < TimeoutError; end
  class NonExistenceTimeoutError < TimeoutError; end
  class ElementVisibilityTimeoutError < TimeoutError; end
  class ElementInvisibilityTimeoutError < TimeoutError; end

  # Generic Block validation family of errors inherit from this error
  class BlockError < SitePrismError; end

  # A Block was passed to the method, which it cannot interpret
  # Formerly known as `UnsupportedBlock`
  class UnsupportedBlockError < BlockError
    def message
      warn 'section and iframe are the only items which can accept a block.'

      "#{super} does not accept blocks."
    end
  end

  # A Block was required, but not passed into the iframe at runtime
  # Formerly known as `BlockMissingError`
  class MissingBlockError < BlockError
    def message
      'You can only use iFrames in a block context - Please pass in a block.'
    end
  end

  # A page was loaded via #load - And then failed one of the load validations
  # that was either pre-defined or defined by the user
  # Formerly known as `NotLoadedError`
  class FailedLoadValidationError < PageLoadError
    def message
      if super == self.class.to_s
        'Failed to load - No reason specified.'
      else
        "Failed to load. Reason: #{super}"
      end
    end
  end
end
