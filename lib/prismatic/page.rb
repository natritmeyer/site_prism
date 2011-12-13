module Prismatic
  class Page
    # Visits the url associated with this page
    # @raise [Prismatic::NoUrlForPage] To load a page the url must be set using Page#load
    def load
      raise Prismatic::NoUrlForPage if url.nil?
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
    
    # Get the url associated with this page
    # @see Prismatic::Page#url
    def self.url
      @url
    end
    
    # Get the url associated with this page
    # @see Prismatic::Page.url
    def url
      self.class.url
    end
  end
end