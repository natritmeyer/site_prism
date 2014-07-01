# encoding: utf-8

class SearchResult < SitePrism::Section
  element :title, 'span.title'
  element :link, 'a'
  element :description, 'span.description'

  def set_cell_value
    execute_script "document.getElementById('first_search_result').children[0].innerHTML = 'wibble'"
  end

  def cell_value
    evaluate_script "document.getElementById('first_search_result').children[0].innerHTML"
  end
end
