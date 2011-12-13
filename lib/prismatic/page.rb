module Prismatic
  class Page
    @@url = ""
    
    def load
      
    end
    
    def self.set_url input
      @@url = input
    end
    
    def url
      @@url
    end
  end
end