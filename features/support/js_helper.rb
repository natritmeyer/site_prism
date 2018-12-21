# frozen_string_literal: true

module JSHelper
  def first_search_result=(value)
    execute_script("#{script} = '#{value}'")
  end

  def first_search_result
    evaluate_script(script)
  end

  def script
    "document.getElementById('first_search_result').children[0].innerHTML"
  end
end
