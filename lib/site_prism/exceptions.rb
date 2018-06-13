# frozen_string_literal: true

module SitePrism
  class NoUrlForPage < StandardError; end
  class NoUrlMatcherForPage < StandardError; end

  class InvalidUrlMatcher < StandardError
    def message
      "Could not automatically match your URL. \
Templated port numbers are unsupported."
    end
  end

  class NoSelectorForElement < StandardError; end

  class TimeoutException < StandardError
    def message
      "Timed out after #{super}s while waiting for block to evaluate as true."
    end
  end

  class TimeOutWaitingForExistenceError < StandardError; end
  class TimeOutWaitingForNonExistenceError < StandardError; end
  class TimeOutWaitingForElementVisibility < StandardError; end
  class TimeOutWaitingForElementInvisibility < StandardError; end

  class UnsupportedBlock < StandardError
    def message
      "#{super} does not accept blocks, did you mean to define a (i)frame?"
    end
  end

  NotLoadedError = Class.new(StandardError)
end
