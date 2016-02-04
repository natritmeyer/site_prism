require 'site_prism/loadable'

module SitePrism
  class Page
    include Capybara::DSL
    include ElementChecker
    include Loadable
    extend ElementContainer

    load_validation do
      [displayed?, "Expected #{current_url} to match #{url_matcher} but it did not."]
    end

    def page
      @page || Capybara.current_session
    end

    # Loads the page.
    # Executes the block, if given, after running load validations on the page.
    #
    # @param expansion_or_html
    # @param block [&block] A block to run once the page is loaded.  The page will yield itself into the block.
    def load(expansion_or_html = {}, &block)
      self.loaded = false

      if expansion_or_html.is_a? String
        @page = Capybara.string(expansion_or_html)
      else
        expanded_url = url(expansion_or_html)
        raise SitePrism::NoUrlForPage if expanded_url.nil?
        visit expanded_url
      end

      when_loaded(&block) if block_given?
    end

    def displayed?(*args)
      expected_mappings = args.last.is_a?(::Hash) ? args.pop : {}
      seconds = !args.empty? ? args.first : Waiter.default_wait_time
      raise SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      begin
        Waiter.wait_until_true(seconds) { url_matches?(expected_mappings) }
      rescue SitePrism::TimeoutException
        false
      end
    end

    def url_matches(seconds = Waiter.default_wait_time)
      return unless displayed?(seconds)

      if url_matcher.is_a?(Regexp)
        regexp_backed_matches
      else
        template_backed_matches
      end
    end

    def regexp_backed_matches
      url_matcher.match(page.current_url)
    end

    def template_backed_matches
      matcher_template.mappings(page.current_url)
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
      @url_matcher || url
    end

    def url(expansion = {})
      return nil if self.class.url.nil?
      Addressable::Template.new(self.class.url).expand(expansion).to_s
    end

    def url_matcher
      self.class.url_matcher
    end

    def secure?
      current_url.start_with? 'https'
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

    def url_matches?(expected_mappings = {})
      case
      when url_matcher.is_a?(Regexp)
        url_matches_by_regexp?
      when url_matcher.respond_to?(:to_str)
        url_matches_by_template?(expected_mappings)
      else
        raise SitePrism::InvalidUrlMatcher
      end
    end

    def url_matches_by_regexp?
      !regexp_backed_matches.nil?
    end

    def url_matches_by_template?(expected_mappings)
      matcher_template.matches?(page.current_url, expected_mappings)
    end

    def matcher_template
      @addressable_url_matcher ||= AddressableUrlMatcher.new(url_matcher)
    end
  end
end
