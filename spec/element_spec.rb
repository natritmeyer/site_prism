# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  shared_examples 'SitePrism Page' do
    it 'should respond to #element' do
      expect(SitePrism::Page).to respond_to(:element)
    end

    it { is_expected.to respond_to(:bob) }
    it { is_expected.to respond_to(:has_bob?) }
    it { is_expected.to respond_to(:has_no_bob?) }
    it { is_expected.to respond_to(:wait_for_bob) }
    it { is_expected.to respond_to(:all_there?) }

    describe '#expected_elements' do
      subject { page.all_there? }
      let(:page) { PageWithAFewElements.new }

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
  end

  context 'with a css element' do
    class Page < SitePrism::Page
      element :bob, 'a.b c.d'
    end

    class PageWithAFewElements < SitePrism::Page
      element :bob, 'a.b c.d'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    subject { Page.new }

    it_behaves_like 'SitePrism Page'
  end

  context 'with an xpath element' do
    class Page < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
    end

    class PageWithAFewElements < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
      element :success_msg, :xpath, '//span[@class="alert-success"]'

      expected_elements :bob
    end

    subject { Page.new }

    it_behaves_like 'SitePrism Page'
  end
end
