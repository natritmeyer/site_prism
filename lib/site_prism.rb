# encoding: utf-8

require 'site_prism/exceptions'
require 'addressable/template'

module SitePrism
  autoload :ElementContainer,  'site_prism/element_container'
  autoload :ElementChecker,  'site_prism/element_checker'
  autoload :Page,  'site_prism/page'
  autoload :Section,  'site_prism/section'
  autoload :Waiter, 'site_prism/waiter'

  class << self
    attr_accessor :use_implicit_waits

    def configure
      yield self
    end
  end

  private

  @use_implicit_waits = false
end
