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
  # it couldn't be parsed by Addressable. It also could be caused by
  # the usage of templated port numbers - which aren't supported
  # Formerly known as `InvalidUrlMatcher`
  class InvalidUrlMatcherError < PageLoadError; end

  # A SitePrism defined DSL item was defined without a selector
  # Formerly known as `NoSelectorForElement`
  class InvalidElementError < SitePrismError; end

  # A tool like Timecop is being used to "freeze time" by overriding Time.now
  # and similar methods. In this case, our waiter functions won't work, because
  # Time.now does not change.
  # If you encounter this issue, check that you are not doing Timecop.freeze without
  # an accompanying Timecop.return.
  # Also check out Timecop.safe_mode https://github.com/travisjeffery/timecop#timecopsafe_mode
  class FrozenInTimeError < SitePrismError; end

  # The condition that was being evaluated inside the block did not evaluate
  # to true within the time limit
  # Formerly known as `TimeoutException`
  class TimeoutError < SitePrismError; end

  # The wait_until_*_visible meta-programmed method didn't evaluate to true
  # within the prescribed time limit
  # Formerly known as `TimeOutWaitingForElementVisibility`
  class ElementVisibilityTimeoutError < TimeoutError; end

  # The wait_until_*_invisible meta-programmed method didn't evaluate to true
  # within the prescribed time limit
  # Formerly known as `TimeOutWaitingForElementInvisibility`
  class ElementInvisibilityTimeoutError < TimeoutError; end

  # Generic Block validation family of errors inherit from this error
  class BlockError < SitePrismError; end

  # A Block was passed to the method, which it cannot interpret
  # Formerly known as `UnsupportedBlock`
  class UnsupportedBlockError < BlockError; end

  # A Block was required, but not supplied
  # Formerly known as `BlockMissingError`
  class MissingBlockError < BlockError; end

  # A page was loaded then failed one of the validations defined by the user
  # Formerly known as `NotLoadedError`
  class FailedLoadValidationError < PageLoadError; end
end
