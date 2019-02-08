# frozen_string_literal: true

class Delayed < SitePrism::Page
  set_url '/slow.htm'
  set_url_matcher(/slow\.htm$/)

  load_validation do
    has_last_link?
  end

  element :last_link, 'a', text: 'slow link4'
end
