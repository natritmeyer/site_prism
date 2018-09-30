# frozen_string_literal: true

class DynamicPage < SitePrism::Page
  set_url '{/letter}.htm'
  set_url_matcher(/\w\.htm$/)

  section :dummy_section, '.first' do
    element :dummy_element_one, '.second'
  end

  element :dummy_element_two, '.third'
end
