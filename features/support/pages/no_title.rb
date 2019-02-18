# frozen_string_literal: true

class NoTitle < SitePrism::Page
  set_url '/no_title.htm'
  set_url_matcher(/no_title\.htm$/)

  load_validation { has_message? }

  element :element_without_selector
  elements :elements_without_selector
  element :message, 'p'
  elements :missing_messages, 'br'
  sections :missing_sections, 'div' do
  end

  expected_elements :message, :missing_messages
end
