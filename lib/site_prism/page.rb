# frozen_string_literal: true

require 'site_prism/loadable'

module SitePrism
  # rubocop:disable Metrics/ClassLength
  class Page
    include Capybara::DSL
    include ElementChecker
    include Loadable
    include DSL

    class << self
      attr_reader :url

      def set_url(page_url)
        @url = page_url.to_s
      end

      def set_url_matcher(page_url_matcher)
        @url_matcher = page_url_matcher
      end

      def url_matcher
        @url_matcher ||= url
      end
    end

    def page
      if defined?(@page)
        @page
      else
        Capybara.current_session
      end
    end

    # Loads the page.
    # @param expansion_or_html
    # @param block [&block] An optional block to run once the page is loaded.
    # The page will yield the block if defined.
    #
    # Executes the block, if given.
    # Runs load validations on the page, unless input is a string
    #
    # When calling #load, all the validations that are set will be ran in order
    def load(expansion_or_html = {}, &block)
      self.loaded = false
      SitePrism.logger.debug("Reset loaded state on #{self.class}.")

      return_yield = if expansion_or_html.is_a?(String)
                       load_html_string(expansion_or_html, &block)
                     else
                       load_html_website(expansion_or_html, &block)
                     end

      # Ensure that we represent that the page we loaded is now indeed loaded!
      # This ensures that future calls to #loaded? do not perform the
      # instance evaluations against all load validations procs another time.
      self.loaded = true

      SitePrism.logger.info("#{self.class} loaded.")
      # Return the yield from the block if there was one, otherwise return true
      return_yield || true
    end

    def displayed?(*args)
      wait_until_displayed(*args)
    rescue SitePrism::TimeoutError
      false
    end

    def wait_until_displayed(*args)
      raise SitePrism::NoUrlMatcherForPageError unless url_matcher

      expected_mappings = args.last.is_a?(::Hash) ? args.pop : {}
      seconds = args&.first || wait_time
      Waiter.wait_until_true(seconds) { url_matches?(expected_mappings) }
    end

    def url_matches(seconds = wait_time)
      return unless displayed?(seconds)

      if url_matcher.is_a?(Regexp)
        regexp_backed_matches
      else
        template_backed_matches
      end
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

    def regexp_backed_matches
      url_matcher.match(page.current_url)
    end

    def template_backed_matches
      matcher_template.mappings(page.current_url)
    end

    def url_matches?(expected_mappings = {})
      if url_matcher.is_a?(Regexp)
        url_matches_by_regexp?
      elsif url_matcher.respond_to?(:to_str)
        url_matches_by_template?(expected_mappings)
      else
        raise SitePrism::InvalidUrlMatcherError
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

    def load_html_string(string)
      @page = Capybara.string(string)
      yield self if block_given?
    end

    def load_html_website(html, &block)
      with_validations = html.delete(:with_validations) { true }
      expanded_url = url(html)
      raise SitePrism::NoUrlForPageError unless expanded_url

      visit expanded_url
      if with_validations
        when_loaded(&block)
      elsif block_given?
        yield self
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
