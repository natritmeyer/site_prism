# encoding: utf-8

class TestSectionExperiments < SitePrism::Page
  set_url '/section_experiments.htm'

  section :parent_section, Parent, '.parent-div'

  sections :search_results, SearchResult, '.search-results .search-result'

  section :anonymous_section, '.anonymous-section' do
    element :title, 'h1'

    def upcase_title_text
      title.text.upcase
    end
  end

  sections :anonymous_sections, 'ul.anonymous-sections li' do
    element :title, 'h1'

    def downcase_title_text
      title.text.downcase
    end
  end
end
