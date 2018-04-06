# frozen_string_literal: true

require 'spec_helper'

class Section < SitePrism::Section; end
class Page < SitePrism::Page; end

describe SitePrism::Page do
  describe '.section' do
    context 'second argument is a Class' do
      class PageWithSection < SitePrism::Page
        section :section, Section, '.section'
      end

      subject(:page_with_section) { PageWithSection.new }

      it { is_expected.to respond_to(:section) }
    end

    context 'second argument is not a Class and a block given' do
      class PageWithAnonymousSection < SitePrism::Page
        section :anonymous_section, '.section' do |s|
          s.element :title, 'h1'
        end
      end

      subject(:page_with_anonymous_section) { PageWithAnonymousSection.new }

      it { is_expected.to respond_to(:anonymous_section) }
    end

    context 'second argument is not a Class and no block given' do
      subject(:invalid_page) { Page.section(:incorrect_section, '.section') }
      let(:error_message) do
        'You should provide section class either as a block, or as the second argument.'
      end

      it 'raises an ArgumentError' do
        expect { invalid_page }
          .to raise_error(ArgumentError)
          .with_message(error_message)
      end
    end
  end
end

describe SitePrism::Section do
  let(:instance) { SitePrism::Section.new(Page.new, locator) }
  let(:locator) { instance_double('Capybara::Node::Element') }
  let(:section_with_block) { SitePrism::Section.new(Page.new, locator) { 1 + 1 } }

  describe 'Object' do
    subject { SitePrism::Section }

    it { is_expected.to respond_to(:element) }
    it { is_expected.to respond_to(:elements) }
  end

  describe '#new' do
    context 'with a block' do
      it 'passes the block to Capybara.within' do
        expect(Capybara).to receive(:within).with(locator)

        section_with_block
      end
    end

    context 'without a block' do
      it 'does not pass a block to Capybara.within' do
        expect(Capybara).not_to receive(:within)

        instance
      end
    end
  end

  describe '#visible?' do
    it 'delegates through root_element' do
      expect(locator).to receive(:visible?)

      instance.visible?
    end
  end

  describe '#text' do
    it 'delegates through root_element' do
      expect(locator).to receive(:text)

      instance.text
    end
  end

  describe '#native' do
    it 'delegates through root_element' do
      expect(locator).to receive(:native)

      instance.native
    end
  end

  describe '#execute_script' do
    it 'delegates through Capybara' do
      expect(Capybara.current_session).to receive(:execute_script).with('JUMP!')

      instance.execute_script('JUMP!')
    end
  end

  describe '#evaluate_script' do
    it 'delegates through Capybara' do
      expect(Capybara.current_session).to receive(:evaluate_script).with('How High?')

      instance.evaluate_script('How High?')
    end
  end

  describe '#parent_page' do
    let(:section) { SitePrism::Section.new(page, '.locator') }
    let(:deeply_nested_section) do
      SitePrism::Section.new(
        SitePrism::Section.new(
          SitePrism::Section.new(
            page, '.locator-section-large'
          ), '.locator-section-medium'
        ), '.locator-small'
      )
    end
    let(:page) { Page.new }

    it 'returns the parent of a section' do
      expect(section.parent_page.class).to eq(Page)

      expect(section.parent_page).to be_a SitePrism::Page
    end

    it 'returns the parent page of a deeply nested section' do
      expect(deeply_nested_section.parent_page.class).to eq(Page)

      expect(deeply_nested_section.parent_page).to be_a SitePrism::Page
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
