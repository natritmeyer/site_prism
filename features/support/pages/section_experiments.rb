# frozen_string_literal: true

class SectionExperiments < SitePrism::Page
  set_url '/section_experiments.htm'

  section :parent_div, ParentDiv, '.parent-div'
  section :removing_parent, RemovingParent, '.removing-parent-div'
  sections :search_results, SearchResults, '.search-results .search-result'

  section :slow_section, '.slow' do
    # This is a duplicate of `parent_div.slow_element`
  end

  section :anonymous_section, '.anonymous-section' do
    element :title, 'h1'
  end

  sections :anonymous_sections, 'ul.anonymous-sections li' do
    element :title, 'h1'
  end

  section :level_1, '.level-1' do
    section :level_2, '.level-2' do
      section :level_3, '.level-3' do
        element :deep_span, '.deep-span'
      end
    end
  end

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
