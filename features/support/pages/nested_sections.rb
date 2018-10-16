# frozen_string_literal: true

class NestedSections < SitePrism::Page
  include JSHelper

  set_url '/nested_sections.htm'

  section :top, Top, '.top-div'
  sections :search_results, SearchResults, '.search-result'

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
end
