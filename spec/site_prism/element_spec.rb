# frozen_string_literal: true

require 'spec_helper'

describe 'Element' do
  shared_examples 'an element' do
    describe '.element' do
      it 'should be settable' do
        expect(SitePrism::Page).to respond_to(:element)

        expect(SitePrism::Section).to respond_to(:element)
      end
    end

    it { is_expected.to respond_to(:bob) }
    it { is_expected.to respond_to(:has_bob?) }
    it { is_expected.to respond_to(:has_no_bob?) }
    it { is_expected.to respond_to(:wait_until_bob_visible) }
    it { is_expected.to respond_to(:wait_until_bob_invisible) }

    describe '#all_there?' do
      subject { page.all_there? }

      context 'with no recursion' do
        it { is_expected.to be_truthy }

        it 'checks only the expected elements' do
          expect(page).to receive(:there?).with(:bob).at_least(:once)
          expect(page).not_to receive(:there?).with(:dave)

          subject
        end
      end
    end

    describe '#elements_present' do
      it 'only lists the SitePrism objects that are present on the page' do
        expect(page.elements_present).to eq(%i[bob success_msg])
      end
    end

    describe '.expected_elements' do
      it 'sets the value of expected_items' do
        expect(klass.expected_items).to eq([:bob])
      end
    end
  end

  context 'defined as css' do
    let(:page) { CSSPage.new }
    let(:klass) { CSSPage }

    subject { page }

    it_behaves_like 'an element'
  end

  context 'defined as xpath' do
    let(:page) { XPathPage.new }
    let(:klass) { XPathPage }

    subject { page }

    it_behaves_like 'an element'
  end
end
