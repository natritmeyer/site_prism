# frozen_string_literal: true

class DynamicPage < SitePrism::Page
  set_url '{/letter}.htm'
  set_url_matcher(/\w\.htm$/)
end
