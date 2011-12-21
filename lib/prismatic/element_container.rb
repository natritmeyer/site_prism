module Prismatic::ElementContainer
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
  def element element_name, element_locator
    create_existence_checker element_name, element_locator
    define_method element_name.to_s do
      find_one element_locator
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
  def elements collection_name, collection_locator
    create_existence_checker collection_name, collection_locator
    define_method collection_name.to_s do
      find_all collection_locator
    end
  end
  alias :collection :elements

  # Creates a method that returns an instance of a {Prismatic::Section}. If a page contains a common section (eg: a search area) that
  # appears on many pages, create a {Prismatic::Section} for it and then expose it in each {Prismatic::Page} that contains the section.
  # Say a search engine website displays the search field and search button on each page and they always have the same IDs, they should
  # be extracted into a {Prismatic::Section} that would look something like this:
  #
  #   class SearchArea < Prismatic::Section
  #     element :search_field, '.q'
  #     element :search_button, '.btnK'
  #   end
  # 
  # ...then that section could be added to any page as follows:
  # 
  #   class SearchPage < Prismatic::Page
  #     section :search_area, SearchArea, '.tsf-p'
  #   end
  #   
  #   class SearchResultsPage < Prismatic::Page
  #     section :search_again, SearchArea, '.tsf-p table'
  #   end
  # 
  # The SearchArea section appears on both pages, but can be invoked by methods specific to the page (eg: 'search_area' and 'search_again')
  # and the root element for the section can be different on the page (eg: '.tsf-p' and '.tsf-p table').
  def section section_name, section_class, section_locator
    define_method section_name do
      section_class.new find_one section_locator
    end
  end
  
  private
  
  def create_existence_checker element_name, element_locator
    define_method "has_#{element_name.to_s}?" do
      has_selector? element_locator
    end
  end
end