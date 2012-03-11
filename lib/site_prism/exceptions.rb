# SitePrism's exceptions...
module SitePrism
  # Raised if you ask a page to load but it hasn't had its url set
  class NoUrlForPage < StandardError; end
  # Raised if you check to see if a page is displayed but it hasn't had its url matcher set
  class NoUrlMatcherForPage < StandardError; end
  # Raised if you ask for an element that hasn't got a locator (i.e. a pending element)
  class NoLocatorForElement < StandardError; end
end

