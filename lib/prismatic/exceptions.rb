module Prismatic
  # Raised if you ask a page to load but it hasn't had its url set
  class NoUrlForPage < StandardError; end
  # Raised if you check to see if a page is displayed but it hasn't had its url matcher set
  class NoUrlMatcherForPage < StandardError; end
end