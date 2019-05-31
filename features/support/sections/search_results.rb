# frozen_string_literal: true

class SearchResults < SitePrism::Section
  include JSHelper

  element :title, 'span.title' # Not present
  element :description, 'span.description'
end
