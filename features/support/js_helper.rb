# frozen_string_literal: true

module JSHelper
  def cell_value=(value)
    execute_script(
      "document.getElementById('first_search_result').children[0].innerHTML =
        '#{value}'"
    )
  end

  def cell_value
    evaluate_script(
      "document.getElementById('first_search_result').children[0].innerHTML"
    )
  end
end
