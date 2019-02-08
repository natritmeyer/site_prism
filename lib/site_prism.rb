# frozen_string_literal: true

require 'site_prism/error'
require 'addressable/template'

module SitePrism
  autoload :AddressableUrlMatcher, 'site_prism/addressable_url_matcher'
  autoload :DSL, 'site_prism/dsl'
  autoload :ElementChecker, 'site_prism/element_checker'
  autoload :Logger, 'site_prism/logger'
  autoload :Page, 'site_prism/page'
  autoload :Section, 'site_prism/section'
  autoload :Waiter, 'site_prism/waiter'

  class << self
    def configure
      yield self
    end

    def logger
      @logger ||= SitePrism::Logger.new.create
    end

    def log_level=(value)
      logger.level = value
    end

    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end
  end
end
