class TestSectionExperiments < SitePrism::Page
  set_url '/section_experiments.htm'

  section :parent_section, Parent, '.parent-div'

  sections :search_results, SearchResult, '.search-results .search-result'

  section :anonymous_section, '.anonymous-section' do |s|
    s.element :title, 'h1'
  end

  sections :anonymous_sections, 'ul.anonymous-sections li' do |s|
    s.element :title, 'h1'
  end
end

