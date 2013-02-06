module SitePrism
  class Page
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    def load
      raise SitePrism::NoUrlForPage if url.nil?
      visit url
    end

    def displayed?
      raise SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      !(page.current_url =~ url_matcher).nil?
    end

    def self.set_url page_url
      @url = page_url
    end

    def self.set_url_matcher page_url_matcher
      @url_matcher = page_url_matcher
    end

    def self.url
      @url
    end

    def self.url_matcher
      @url_matcher
    end

    def url
      self.class.url
    end

    def url_matcher
      self.class.url_matcher
    end

    def secure?
      !current_url.match(/^https/).nil?
    end

    def title
      title_selector = 'html > head > title'
      using_wait_time(0) { page.find(title_selector).text if page.has_selector?(title_selector) }
    end

    private

    def find_first *find_args
      first *find_args
    end

    def find_all *find_args
      all *find_args
    end

    def element_exists? *find_args
      has_selector? *find_args
    end
  end
end

