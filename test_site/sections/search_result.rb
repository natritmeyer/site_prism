class SearchResult < SitePrism::Section
  element :title, 'span.title'
  element :link, 'a'
  element :description, 'span.description'
end