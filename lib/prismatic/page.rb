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
    # @return [String] the text value of the title element within the page's head block
    # @return [nil] if the page hasn't got a title return nil
    def title
      title_selector = 'html > head > title'
      using_wait_time(0) { page.find(title_selector).text if page.has_selector?(title_selector) }
    end
    
    # Creates two methods; the first method has the same name as the element_name parameter and returns the capybara element
    # located by the element_locator parameter when the method is called. The second method generated has a name with a format
    # of: 'has_#\{element_name}?' which returns true if the element as located by the element_locator parameter exists, false
    # if it doesn't
    # @param [Symbol] element_name The name of the element
    # @param [String] element_locator The CSS locator to find the element
    # @example
    #   class HomePage < Prismatic::Page
    #     element :search_link, 'div.search > a'
    #   end
    #   home = HomePage.new
    #   
    #   #the element method created 2 methods...
    #   home.search_link #=> returns the capybara element located by the element_locator parameter
    #   home.has_search_link? #=> returns true if the capybara element as located by the element_locator exists, false if it doesn't
    #   
    #   #The has_search_link? method allows use of magic matchers in rspec/cucumber:
    #   home.should have_search_link
    #   home.should_not have_search_link
    def self.element element_name, element_locator
      create_existence_checker element_name, element_locator
      define_method element_name.to_s do
        find element_locator
      end
    end
    
    # Works in the same way as {Prismatic::Page.element} in that it will generate two methods; one to check existence of
    # the element (in the format 'has_#\{element_name}?'), and another to return not a single element, but an array of elements
    # found by the css locator
    # @example
    #   class HomePage < Prismatic::Page
    #     elements :app_links, '.title-links > a'
    #   end
    #   home = HomePage.new
    #   
    #   home.should have_app_links
    #   home.app_links #=> [#<Capybara::Element tag="a">, #<Capybara::Element tag="a">, #<Capybara::Element tag="a">]
    #   home.app_links.map {|link| link.text}.should == ['Finance', 'Maps', 'Blogs']
    def self.elements collection_name, collection_locator
      create_existence_checker collection_name, collection_locator
      define_method collection_name.to_s do
        all collection_locator
      end
    end
    
    private
    
    def self.create_existence_checker element_name, element_locator
      define_method "has_#{element_name.to_s}?" do
        has_selector? element_locator
      end
    end
  end
end