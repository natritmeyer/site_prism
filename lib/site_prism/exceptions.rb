module SitePrism
  class NoUrlForPage < StandardError; end
  class NoUrlMatcherForPage < StandardError; end
  class NoLocatorForElement < StandardError; end
  class TimeOutWaitingForElementVisibility < StandardError; end
  class TimeOutWaitingForElementInvisibility < StandardError; end
end

