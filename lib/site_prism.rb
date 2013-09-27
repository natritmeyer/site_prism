module SitePrism
  autoload :Addressable,  'addressable/template'
  autoload :Version,  'site_prism/version'
  autoload :ElementContainer,  'site_prism/element_container'
  autoload :ElementChecker,  'site_prism/element_checker'
  autoload :Page,  'site_prism/page'
  autoload :Section,  'site_prism/section'

  autoload :NoUrlForPage,  'site_prism/exceptions'
  autoload :NoUrlMatcherForPage,  'site_prism/exceptions'
  autoload :NoSelectorForElement,  'site_prism/exceptions'
  autoload :TimeOutWaitingForElementVisibility,  'site_prism/exceptions'
  autoload :TimeOutWaitingForElementInvisibility,  'site_prism/exceptions'

  class AccessDeniedError < RuntimeError ; end
  class AssertAccessDeniedError < AccessDeniedError ; end
end
