module SitePrism
  class Page
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    def load(expansion = {})
      expanded_url = url(expansion)
      raise SitePrism::NoUrlForPage if expanded_url.nil?
      visit expanded_url
    end

    def displayed?(seconds = Waiter.default_wait_time)
      raise SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      begin
        Waiter.wait_until_true(seconds) {
          !(page.current_url =~ url_matcher).nil?
        }
      rescue SitePrism::TimeoutException=>e
        return false
      end
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

    def url(expansion = {})
      return nil if self.class.url.nil?
      Addressable::Template.new(self.class.url).expand(expansion).to_s
    end

    def url_matcher
      self.class.url_matcher
    end

    def secure?
      !current_url.match(/^https/).nil?
    end

    private

    def find_first *find_args
      find *find_args
    end

    def find_all *find_args
      all *find_args
    end

    def element_exists? *find_args
      has_selector? *find_args
    end

    def element_does_not_exist? *find_args
      has_no_selector? *find_args
    end
  end
end

