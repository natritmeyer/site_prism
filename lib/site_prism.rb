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

    # The SitePrism logger object - This is called automatically in several
    # locations and will log messages according to the normal Ruby protocol
    # To alter the log_level (or check the log level); call #log_level= or
    # #log_level
    #
    # This logger object can also be used to manually log messages
    #
    # To Manually log a message
    #   SitePrism.logger.info('Information')
    #   SitePrism.logger.debug('Input debug message')
    def logger
      @logger ||= SitePrism::Logger.new.create
    end

    # `Logger#reopen` was added in Ruby 2.3 - Which is now the minimum version
    # for the site_prism gem
    #
    # This writer method allows you to configure where you want the output of
    # the site_prism logs to go (Default is $stdout)
    #
    # example: SitePrism.log_output('site_prism.log') would save all
    # log messages to `site_prism.log`
    def log_output=(logdev)
      logger.reopen(logdev)
    end

    # To enable full logging
    #   SitePrism.log_level = :DEBUG
    #
    # To disable all logging (Done by default)
    #   SitePrism.log_level = :UNKNOWN
    def log_level=(value)
      logger.level = value
    end

    # To query what level is being logged
    #   SitePrism.log_level
    #   => :UNKNOWN # By default
    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end
  end
end
