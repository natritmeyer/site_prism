module Prismatic
  class Page
    def load
      raise Prismatic::NoUrlForPage if url.nil?
    end
    
    def self.set_url input
      @url = input
    end
    
    def self.url
      @url
    end
    
    def url
      self.class.url
    end
  end
end