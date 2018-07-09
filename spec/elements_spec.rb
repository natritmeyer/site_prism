# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'elements' do
    it { is_expected.to respond_to(:bobs) }
    it { is_expected.to respond_to(:has_bobs?) }
    it { is_expected.to respond_to(:has_no_bobs?) }
    it { is_expected.to respond_to(:wait_for_bobs) }
    it { is_expected.to respond_to(:wait_for_no_bobs) }
    it { is_expected.to respond_to(:all_there?) }

    it 'should return an enumerable result' do
      expect(subject.bobs).to be_a Capybara::Result
    end
  end

  context 'with css elements' do
    class PageCSS < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end

    subject { page }
    let(:page) { PageCSS.new }
    let(:klass) { PageCSS }

    it_behaves_like 'elements'
  end

  context 'with xpath elements' do
    class PageXPath < SitePrism::Page
      elements :bobs, '//a[@class="b"]//c[@class="d"]'
    end

    subject { page }
    let(:page) { PageXPath.new }
    let(:klass) { PageXPath }

    it_behaves_like 'elements'
  end
end
