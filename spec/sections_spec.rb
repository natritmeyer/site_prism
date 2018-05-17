# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  subject { Page.new }

  class PluralSections < SitePrism::Section; end

  class Page < SitePrism::Page
    sections :plural_sections, PluralSections, '.tim'
  end

  context 'with sections `plural_sections` defined' do
    it { is_expected.to respond_to(:plural_sections) }
    it { is_expected.to respond_to(:has_plural_sections?) }
  end
end
