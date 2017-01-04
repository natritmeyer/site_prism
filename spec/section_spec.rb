# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  describe '.section' do
    context 'second argument is not a Class and a block given' do
      context 'block given' do
        it 'should create an anonymous section with the block' do
          class PageWithSection < SitePrism::Page
            section :anonymous_section, '.section' do |s|
              s.element :title, 'h1'
            end
          end

          page = PageWithSection.new
          expect(page).to respond_to(:anonymous_section)
        end
      end
    end

    context 'second argument is not a class and no block given' do
      subject(:section) { Page.section(:incorrect_section, '.section') }

      it 'should raise an ArgumentError' do
        class Page < SitePrism::Page; end

        expect { section }
          .to raise_error(ArgumentError)
          .with_message('You should provide section class either as a block, or as the second argument.')
      end
    end
  end
end

describe SitePrism::Section do
  let(:a_page) { class Page < SitePrism::Page; end }

  it 'responds to element' do
    expect(SitePrism::Section).to respond_to(:element)
  end

  it 'responds to elements' do
    expect(SitePrism::Section).to respond_to(:elements)
  end

  it 'passes a given block to Capybara.within' do
    expect(Capybara).to receive(:within).with('div')

    SitePrism::Section.new(a_page, 'div') { 1 + 1 }
  end

  it 'does not require a block' do
    expect(Capybara).not_to receive(:within)

    SitePrism::Section.new(a_page, 'div')
  end

  describe 'instance' do
    subject(:section) { SitePrism::Section.new('parent', 'locator') }

    it 'responds to javascript methods' do
      expect(section).to respond_to(:execute_script)
      expect(section).to respond_to(:evaluate_script)
    end

    it 'responds to #visible? method' do
      expect(section).to respond_to(:visible?)
    end

    it 'responds to Capybara methods' do
      expect(section).to respond_to(*Capybara::Session::DSL_METHODS)
    end
  end

  describe 'page' do
    subject(:section) { SitePrism::Section.new('parent', root_element).page }

    let(:root_element) { 'root' }

    it { is_expected.to eq('root') }

    context 'when root element is nil' do
      let(:root_element) { nil }

      before { allow(Capybara).to receive(:current_session).and_return('current session') }

      it { is_expected.to eq('current session') }
    end
  end
end
