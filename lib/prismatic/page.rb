module Prismatic
  class Page
    include Capybara::DSL
    
    # Visits the url associated with this page
    # @raise [Prismatic::NoUrlForPage] To load a page the url must be set using {#load}
    def load
      raise Prismatic::NoUrlForPage if url.nil?
      visit url
    end
    
    # Checks to see if we're on this page or not
    # @return true if the current url matches the url matcher that has been set, false if it doesn't
    def displayed?
      raise Prismatic::NoUrlMatcherForPage if url_matcher.nil?
      !(page.current_url =~ url_matcher).nil?
    end
    
    # Set the url associated with this page
    # @param [String] URL the portion of the url that identifies this page when appended onto Capybara's app_host. Calling {Prismatic::Page#load} causes Capybara to visit this page.
    # @example Setting a page's url
    #   class SearchPage < Prismatic::Page
    #     set_url "/search"
    #   end
    def self.set_url input
      @url = input
    end
    
    def self.set_url_matcher input
      @url_matcher = input
    end
    
    # Get the url associated with this page
    # @see Prismatic::Page#url
    # @return [String] the url originally set in {.set_url}
    def self.url
      @url
    end
    
    def self.url_matcher
      @url_matcher
    end
    
    # Get the url associated with this page
    # @see Prismatic::Page.url
    def url
      self.class.url
    end
    
    def url_matcher
      self.class.url_matcher
    end
  end
end