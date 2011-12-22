module Prismatic
  # Subclasses of {Prismatic::Page} represent pages in your app.
  #   class Home < Prismatic::Page
  #   end
  # 
  # The above is an example of how to make a class representing the home page. There are a number of properties that can be
  # set on a page - here is an example of a more fully spec'ed out page:
  #   class Home < Prismatic::Page
  #     set_url "/"
  #     set_url_matcher /\/home.htm$/
  #   end
  class Page
    include Capybara::DSL
    extend ElementContainer
    
    # Visits the url associated with this page
    # @raise [Prismatic::NoUrlForPage] To load a page the url must be set using {.set_url}
    def load
      raise Prismatic::NoUrlForPage if url.nil?
      visit url
    end
    
    # Checks to see if we're on this page or not
    # @return true if the browser's current url matches the {.url_matcher} that has been set, false if it doesn't
    # @raise [Prismatic::NoUrlMatcherForPage] To check whether we're on this page or not the url matcher must be set using {.set_url_matcher}
    # @example
    #   class SearchPage < Prismatic::Page
    #     set_url_matcher /\/search.htm$/
    #   end
    #   search_page = SearchPage.new
    #   search_page.load
    #   puts "We're on the search page" if search_page.displayed?
    #   search_page.should be_displayed
    def displayed?
      raise Prismatic::NoUrlMatcherForPage if url_matcher.nil?
      !(page.current_url =~ url_matcher).nil?
    end
    
    # Set the url associated with this page
    # @param [String] page_url the portion of the url that identifies this page when appended onto Capybara's app_host. Calling {Prismatic::Page#load} causes Capybara to visit this page.
    # @example
    #   class SearchPage < Prismatic::Page
    #     set_url "/search.htm"
    #   end
    def self.set_url page_url
      @url = page_url
    end
    
    # Set the url matcher associated with this page
    # @param [Regexp] page_url_matcher a regular expression that when compared to the current browser url will match if we're on this page or not match if we're not on this page
    # @example
    #   class SearchPage < Prismatic::Page
    #     set_url_matcher /\/search.htm$/
    #   end
    def self.set_url_matcher page_url_matcher
      @url_matcher = page_url_matcher
    end
    
    # Get the url associated with this page
    # @see Prismatic::Page#url
    # @return [String] the url originally set in {.set_url}
    def self.url
      @url
    end
    
    # Get the url matcher associated with this page
    # @see Prismatic::Page#url_matcher
    # @return [Regexp] the url matcher originally set in {.set_url_matcher}
    def self.url_matcher
      @url_matcher
    end
    
    # Get the url associated with this page
    # @see Prismatic::Page.url
    def url
      self.class.url
    end
    
    # Get the url matcher associated with this page
    # @see Prismatic::Page.url_matcher
    def url_matcher
      self.class.url_matcher
    end
    
    # Gets the title of the current page
    # @return [String, nil] the text value of the title element within the page's head block
    def title
      title_selector = 'html > head > title'
      using_wait_time(0) { page.find(title_selector).text if page.has_selector?(title_selector) }
    end
    
    private
    
    # Page specific element finder
    def find_one locator
      find locator
    end
    
    # Page specific elements finder
    def find_all locator
      all locator
    end
    
    def element_exists? locator
      has_selector? locator
    end
  end
end