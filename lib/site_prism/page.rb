# encoding: utf-8

module SitePrism
  class Page
    include Capybara::DSL
    include ElementChecker
    extend ElementContainer

    def page
      @page || Capybara.current_session
    end

    def load(expansion_or_html = {})
      if expansion_or_html.is_a? String
        @page = Capybara.string(expansion_or_html)
      else
        expanded_url = url(expansion_or_html)
        fail SitePrism::NoUrlForPage if expanded_url.nil?
        visit expanded_url
      end
    end

    def displayed?(seconds = Waiter.default_wait_time)
      fail SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      begin
        Waiter.wait_until_true(seconds) do
          !(page.current_url =~ url_matcher).nil?
        end
      rescue SitePrism::TimeoutException
        false
      end
    end

    def self.set_url(page_url)
      @url = page_url.to_s
    end

    def self.set_url_matcher(page_url_matcher)
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

    def find_first(*find_args)
      find(*find_args)
    end

    def find_all(*find_args)
      all(*find_args)
    end

    def element_exists?(*find_args)
      has_selector?(*find_args)
    end

    def element_does_not_exist?(*find_args)
      has_no_selector?(*find_args)
    end
  end
end
