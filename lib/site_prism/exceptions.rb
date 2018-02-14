module SitePrism
  class NoUrlForPage < StandardError; end
  class NoUrlMatcherForPage < StandardError; end
  class InvalidUrlMatcher < StandardError; end
  class NoSelectorForElement < StandardError; end
  class TimeoutException < StandardError; end
  class TimeOutWaitingForElementVisibility < StandardError; end
  class TimeOutWaitingForElementInvisibility < StandardError; end
  class UnsupportedBlock < StandardError; end
  NotLoadedError = Class.new(StandardError)
end
