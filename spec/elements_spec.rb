# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'elements' do
    it 'should return an enumerable result' do
      expect(page.bobs).to be_a Capybara::Result
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

    let(:page) { PageCSS3.new }
    let(:klass) { PageCSS3 }

    it_behaves_like 'elements'
  end

  context 'with xpath elements' do
    class PageXPath3 < SitePrism::Page
      elements :bobs, '//a[@class="b"]//c[@class="d"]'
    end

    let(:page) { PageXPath3.new }
    let(:klass) { PageXPath3 }

    it_behaves_like 'elements'
  end
end
