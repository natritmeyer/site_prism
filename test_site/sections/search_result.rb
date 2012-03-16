class SearchResult < SitePrism::Section
  element :title, 'span.title'
  element :link, 'a'
  element :description, 'span.description'

  def set_cell_value
    execute_script %Q{ document.getElementById("first_search_result").children[0].innerHTML = "wibble" }
  end

  def cell_value
    evaluate_script %Q{ document.getElementById("first_search_result").children[0].innerHTML }
  end
end

