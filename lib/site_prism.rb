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
    attr_accessor :use_implicit_waits,
                  :default_load_validations

    def configure
      yield self
    end
  end

  @default_load_validations = true
  @use_implicit_waits = false
end
