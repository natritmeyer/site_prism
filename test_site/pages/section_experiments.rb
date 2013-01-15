class TestSectionExperiments < SitePrism::Page
  set_url '/section_experiments.htm'

  section :parent_section, Parent, '.parent-div'

  sections :search_results, SearchResult, '.search-results .search-result'
end

