# frozen_string_literal: true

require 'site_prism/error'
require 'addressable/template'

module SitePrism
  autoload :ElementContainer, 'site_prism/element_container'
  autoload :ElementChecker, 'site_prism/element_checker'
  autoload :Page, 'site_prism/page'
  autoload :Section, 'site_prism/section'
  autoload :Waiter, 'site_prism/waiter'
  autoload :AddressableUrlMatcher, 'site_prism/addressable_url_matcher'

  class << self
    def configure
      warn 'SitePrism configuration is now removed.'
      warn 'All options fed directly from Capybara.'
    end
  end
end
