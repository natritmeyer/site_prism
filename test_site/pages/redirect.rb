# encoding: utf-8

class RedirectPage < SitePrism::Page
  set_url '/redirect.htm'
  set_url_matcher(/redirect\.htm$/)
end
