# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'SitePrism Page' do
    it 'responds to #element' do
      expect(SitePrism::Page).to respond_to(:element)
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

    describe '.expected_elements' do
      it 'sets the value of expected_items' do
        expect(klass.expected_items).to eq([:bob])
      end
    end
  end

  context 'with css elements' do
    class PageCSS < SitePrism::Page
      element :bob, 'a.b c.d'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    subject { PageCSS.new }
    let(:page) { PageCSS.new }
    let(:klass) { PageCSS }

    it_behaves_like 'SitePrism Page'
  end

  context 'with xpath elements' do
    class PageXPath < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
      element :success_msg, :xpath, '//span[@class="alert-success"]'

      expected_elements :bob
    end

    subject { PageXPath.new }
    let(:page) { PageXPath.new }
    let(:klass) { PageXPath }

    it_behaves_like 'SitePrism Page'
  end
end
