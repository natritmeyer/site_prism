module Prismatic
  class Page
    #visits the url associated with this page
    def load
      raise Prismatic::NoUrlForPage if url.nil?
    end
    
    #set the url associated with this page
    #  class SearchPage < Prismatic::Page
    #    set_url "/search"
    #  end
    def self.set_url input
      @url = input
    end
    
    #get the url associated with this page
    def self.url
      @url
    end
    
    #get the url associated with this page
    def url
      self.class.url
    end
  end
end