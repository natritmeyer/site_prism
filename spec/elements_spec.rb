# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'elements' do
    it { is_expected.to respond_to(:bobs) }
    it { is_expected.to respond_to(:has_bobs?) }
    it { is_expected.to respond_to(:has_no_bobs?) }
    it { is_expected.to respond_to(:wait_until_bobs_visible) }
    it { is_expected.to respond_to(:wait_until_bobs_invisible) }
    it { is_expected.to respond_to(:all_there?) }

    it 'should return an enumerable result' do
      expect(subject.bobs).to be_a Capybara::Result
    end

    describe '.elements' do
      it 'should be settable' do
        expect(SitePrism::Page).to respond_to(:elements)

        expect(SitePrism::Section).to respond_to(:elements)
      end
    end
  end

  context 'with css elements' do
    class PageCSS3 < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end

    subject { page }
    let(:page) { PageCSS3.new }
    let(:klass) { PageCSS3 }

    it_behaves_like 'elements'
  end

  context 'with xpath elements' do
    class PageXPath3 < SitePrism::Page
      elements :bobs, '//a[@class="b"]//c[@class="d"]'
    end

    subject { page }
    let(:page) { PageXPath3.new }
    let(:klass) { PageXPath3 }

    it_behaves_like 'elements'
  end
end
