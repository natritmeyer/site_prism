# frozen_string_literal: true

class TestSectionExperiments < SitePrism::Page
  set_url '/section_experiments.htm'

  section :parent_section, Parent, '.parent-div'
  section :removing_parent_section, Parent, '.removing-parent-div'
  sections :search_results, SearchResult, '.search-results .search-result'

  section :anonymous_section, '.anonymous-section' do
    element :title, 'h1'
  end

  sections :anonymous_sections, 'ul.anonymous-sections li' do
    element :title, 'h1'

    def downcase_title_text
      title.text.downcase
    end
  end

  sections :level_1, '.level-1' do
    sections :level_2, '.level-2' do
      sections :level_3, '.level-3' do
        sections :level_4, '.level-4' do
          sections :level_5, '.level-5' do
            element :deep_span, '.deep-span'
          end
        end
      end
    end
  end
end
