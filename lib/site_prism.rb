# frozen_string_literal: true

require 'site_prism/error'
require 'addressable/template'

module SitePrism
  autoload :AddressableUrlMatcher, 'site_prism/addressable_url_matcher'
  autoload :ElementChecker, 'site_prism/element_checker'
  autoload :ElementContainer, 'site_prism/element_container'
  autoload :Logger, 'site_prism/logger'
  autoload :Page, 'site_prism/page'
  autoload :Section, 'site_prism/section'
  autoload :Waiter, 'site_prism/waiter'

  class << self
    attr_writer :enable_logging

    def configure
      yield self
    end

    def logger
      @logger ||= SitePrism::Logger.new.create
    end

    def enable_logging
      @enable_logging ||= false
    end
  end
end
