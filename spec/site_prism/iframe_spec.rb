# frozen_string_literal: true

require 'spec_helper'

describe 'iFrame' do
  let!(:locator) { instance_double('Capybara::Node::Element') }

  shared_examples 'iFrame' do
    it 'cannot be called out of block context' do
      expect { page.iframe }.to raise_error(SitePrism::MissingBlockError)
    end

    describe 'A Page with an iFrame contained within' do
      it 'uses #within_frame delegated through Capybara.current_session' do
        expect(Capybara.current_session)
          .to receive(:within_frame)
          .with(*frame_caller_args)
          .and_yield

        expect_any_instance_of(frame_class)
          .to receive(:_find)
          .with(*element_caller_args)
          .and_return(locator)

        page.iframe(&:element_one)
      end
    end

    describe 'A Section with an iFrame contained within' do
      before do
        allow(page)
          .to receive(:_find)
          .with(*section_locator)
          .and_return(locator)
      end

      it 'uses #within_frame delegated through Capybara.current_session' do
        expect(Capybara.current_session)
          .to receive(:within_frame)
          .with(*frame_caller_args)
          .and_yield

        expect_any_instance_of(frame_class)
          .to receive(:_find)
          .with(*element_caller_args)
          .and_return(locator)

        page.section_one.iframe(&:element_one)
      end
    end
  end

  context 'with css elements' do
    let(:page) { CSSPage.new }
    let(:klass) { CSSPage }
    let(:frame_caller_args) { [:css, '.iframe'] }
    let(:frame_class) { CSSIFrame }
    let(:section_locator) { ['span.locator', wait: 0] }
    let(:element_caller_args) { ['.some_element', wait: 0] }

    it_behaves_like 'iFrame'
  end

  context 'with xpath elements' do
    let(:page) { XPathPage.new }
    let(:klass) { XPathPage }
    let(:frame_caller_args) { [:css, '.iframe'] }
    let(:frame_class) { CSSIFrame }
    let(:section_locator) { ['//span[@class="locator"]', wait: 0] }
    let(:element_caller_args) { ['.some_element', wait: 0] }

    it_behaves_like 'iFrame'
  end
end
