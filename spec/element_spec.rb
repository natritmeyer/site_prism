# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'element' do
    describe '.element' do
      it 'should be settable' do
        expect(SitePrism::Page).to respond_to(:element)

        expect(SitePrism::Section).to respond_to(:element)
      end
    end

    it { is_expected.to respond_to(:bob) }
    it { is_expected.to respond_to(:has_bob?) }
    it { is_expected.to respond_to(:has_no_bob?) }
    it { is_expected.to respond_to(:wait_for_bob) }
    it { is_expected.to respond_to(:wait_for_no_bob) }
    it { is_expected.to respond_to(:all_there?) }

    describe '#all_there?' do
      subject { page.all_there? }

      before do
        allow(page).to receive(:has_bob?).and_return(true)
        allow(page).to receive(:has_success_msg?).and_return(false)
      end

      it { is_expected.to be_truthy }

      it 'checks only the expected elements' do
        expect(page).to receive(:has_bob?).at_least(:once)
        expect(page).not_to receive(:has_success_msg?)

        subject
      end
    end

    describe '#elements_present' do
      before do
        allow(page).to receive(:there?).with(:bob).and_return(true)
        allow(page).to receive(:there?).with(:dave).and_return(false)
        allow(page).to receive(:there?).with(:success_msg).and_return(true)
        allow(page).to receive(:there?).with(:iframe).and_return(false)
      end

      it 'only lists the SitePrism objects that are present on the page' do
        p subject

        expect(subject.elements_present).to eq(%i[bob success_msg])
      end
    end

    describe '.expected_elements' do
      it 'sets the value of expected_items' do
        expect(klass.expected_items).to eq([:bob])
      end
    end
  end

  context 'with css elements' do
    class PageCSS < SitePrism::Page
      element :bob, 'a.b c.d'
      element :dave, 'w.x y.z'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    subject { page }
    let(:page) { PageCSS.new }
    let(:klass) { PageCSS }

    it_behaves_like 'element'
  end

  context 'with xpath elements' do
    class PageXPath < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
      element :dave, :xpath, '//w[@class="x"]//y[@class="z"]'
      element :success_msg, :xpath, '//span[@class="alert-success"]'

      expected_elements :bob
    end

    subject { page }
    let(:page) { PageXPath.new }
    let(:klass) { PageXPath }

    it_behaves_like 'element'
  end
end
