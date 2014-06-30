module SitePrism
  class NoUrlForPage < StandardError; end
  class NoUrlMatcherForPage < StandardError; end
  class NoSelectorForElement < StandardError; end
  class TimeoutException < StandardError; end
  class TimeOutWaitingForElementVisibility < StandardError; end
  class TimeOutWaitingForElementInvisibility < StandardError; end
end
