# frozen_string_literal: true

require 'site_prism/loadable'

module SitePrism
  # rubocop:disable Metrics/ClassLength
  class Page
    include Capybara::DSL
    include ElementChecker
    include Loadable
    include ElementContainer

    # When instantiating the page. A default validation will be added to all
    # validations you define and add to the Page Class.
    # When calling #load, all of the validations that are set will be ran
    # in order, with the default "displayed?" validation being ran _LAST_
    def initialize
      add_displayed_validation
    end

    def page
      @page || Capybara.current_session
    end

    # Loads the page.
    # @param expansion_or_html
    # @param block [&block] An optional block to run once the page is loaded.
    # The page will yield the block if defined.
    #
    # Executes the block, if given.
    # Runs load validations on the page, unless input is a string
    def load(expansion_or_html = {}, &block)
      self.loaded = false

      if expansion_or_html.is_a?(String)
        @page = Capybara.string(expansion_or_html)
        yield self if block_given?
      else
        expanded_url = url(expansion_or_html)
        raise SitePrism::NoUrlForPage if expanded_url.nil?
        visit expanded_url
        when_loaded(&block) if block_given?
      end
    end

    def displayed?(*args)
      expected_mappings = args.last.is_a?(::Hash) ? args.pop : {}
      seconds = !args.empty? ? args.first : Capybara.default_max_wait_time

      raise SitePrism::NoUrlMatcherForPage if url_matcher.nil?
      begin
        Waiter.wait_until_true(seconds) { url_matches?(expected_mappings) }
      rescue SitePrism::TimeoutException
        false
      end
    end

    def url_matches(seconds = Capybara.default_max_wait_time)
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

    class << self
      attr_reader :url
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
      page.current_url.start_with?('https')
    end

    private

    def _find(*find_args)
      page.find(*find_args)
    end

    def _all(*find_args)
      page.all(*find_args)
    end

    def element_exists?(*find_args)
      page.has_selector?(*find_args)
    end

    def element_does_not_exist?(*find_args)
      page.has_no_selector?(*find_args)
    end

    def url_matches?(expected_mappings = {})
      if url_matcher.is_a?(Regexp)
        url_matches_by_regexp?
      elsif url_matcher.respond_to?(:to_str)
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
      @matcher_template ||= AddressableUrlMatcher.new(url_matcher)
    end

    def add_displayed_validation
      self.class.load_validation do
        [
          displayed?,
          "Expected #{current_url} to match #{url_matcher} but it did not."
        ]
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
