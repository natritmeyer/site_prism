# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  subject { Page.new }

  class SingleSection < SitePrism::Section; end
  class PluralSections < SitePrism::Section; end

  class Page < SitePrism::Page
    section  :single_section,  SingleSection, '.bob'
    sections :plural_sections, PluralSections, '.tim'
  end

  describe '.section' do
    it 'should be callable' do
      expect(SitePrism::Page).to respond_to(:section)
    end

    it { is_expected.to respond_to(:single_section) }
    it { is_expected.to respond_to(:has_single_section?) }
  end

  describe '.sections' do
    it 'should be callable' do
      expect(SitePrism::Page).to respond_to(:sections)
    end

    it { is_expected.to respond_to(:plural_sections) }
    it { is_expected.to respond_to(:has_plural_sections?) }
  end
end
