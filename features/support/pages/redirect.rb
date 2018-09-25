# frozen_string_literal: true

class Redirect < SitePrism::Page
  set_url '/redirect.htm'
  set_url_matcher(/redirect\.htm$/)
end
