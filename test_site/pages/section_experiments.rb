class TestSectionExperiments < SitePrism::Page
  set_url "file://" + Dir.pwd + "/test_site/html/section_experiments.htm"

  section :parent_section, Parent, '.parent-div'

  sections :search_results, SearchResult, '.search-results .search-result'
end

