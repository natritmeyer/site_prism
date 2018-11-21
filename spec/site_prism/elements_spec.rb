# frozen_string_literal: true

require 'spec_helper'

describe 'Elements' do
  shared_examples 'elements' do
    describe '.elements' do
      it 'should be settable' do
        expect(SitePrism::Page).to respond_to(:elements)

        expect(SitePrism::Section).to respond_to(:elements)
      end
    end

    it 'should return an enumerable result' do
      expect(page.elements_one).to be_a Capybara::Result
    end
  end

  context 'defined as css' do
    let(:page) { CSSPage.new }
    let(:klass) { CSSPage }

    it_behaves_like 'elements'
  end

  context 'defined as xpath' do
    let(:page) { XPathPage.new }
    let(:klass) { XPathPage }

    it_behaves_like 'elements'
  end
end
