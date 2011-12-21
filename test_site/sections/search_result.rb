class SearchResult < Prismatic::Section
  element :title, 'span.title'
  element :link, 'a'
  element :description, 'span.description'
end