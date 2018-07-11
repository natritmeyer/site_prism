# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  class Section < SitePrism::Section; end
  class Page < SitePrism::Page; end
  let(:dont_wait) { { wait: false } }

  describe '.section' do
    it 'should be settable' do
      expect(SitePrism::Page).to respond_to(:section)

      expect(SitePrism::Section).to respond_to(:section)
    end
  end

  describe 'a section' do
    class SingleSection < SitePrism::Section
      element :single_section_element, '.foo'
    end

    class PageWithSections < SitePrism::Page
      section :single_section, SingleSection, '.bob'

      section :section_with_a_block, SingleSection, '.bob' do
        element :block_element, '.btn'
      end
    end

    subject { PageWithSections.new }

    before do
      allow(subject).to receive(:_find).and_return(:element)
    end

    it 'should be an instance of the defined section class' do
      expect(subject.section_with_a_block.class.ancestors)
        .to include(SingleSection)
    end

    it 'should have elements from the defined section' do
      expect(subject.section_with_a_block)
        .to respond_to(:single_section_element)
    end

    it 'should have elements from the block' do
      expect(subject.section_with_a_block).to respond_to(:block_element)
    end

    context 'second argument is a Class' do
      class PageWithSection < SitePrism::Page
        section :section, Section, '.section'
      end

      subject { PageWithSection.new }

      it { is_expected.to respond_to(:section) }
      it { is_expected.to respond_to(:has_section?) }
      it { is_expected.to respond_to(:has_no_section?) }
      it { is_expected.to respond_to(:wait_for_section) }
      it { is_expected.to respond_to(:wait_for_no_section) }
      it { is_expected.to respond_to(:all_there?) }
    end

    context 'second argument is not a Class and a block given' do
      class PageWithAnonymousSection < SitePrism::Page
        section :anonymous_section, '.section' do
          element :title, 'h1'
        end
      end

      subject { PageWithAnonymousSection.new }

      it { is_expected.to respond_to(:anonymous_section) }
      it { is_expected.to respond_to(:has_anonymous_section?) }
      it { is_expected.to respond_to(:has_no_anonymous_section?) }
      it { is_expected.to respond_to(:wait_for_anonymous_section) }
      it { is_expected.to respond_to(:wait_for_no_anonymous_section) }
      it { is_expected.to respond_to(:all_there?) }
    end

    context 'second argument is a Class and a block given' do
      class PageWithAnonymousSection < SitePrism::Page
        section :anonymous_section, Section, '.section' do
          element :title, 'h1'
        end
      end

      subject { PageWithAnonymousSection.new }

      it { is_expected.to respond_to(:anonymous_section) }
      it { is_expected.to respond_to(:has_anonymous_section?) }
      it { is_expected.to respond_to(:has_no_anonymous_section?) }
      it { is_expected.to respond_to(:wait_for_anonymous_section) }
      it { is_expected.to respond_to(:wait_for_no_anonymous_section) }
      it { is_expected.to respond_to(:all_there?) }
    end

    context 'second argument is not a Class and no block given' do
      let(:section) { Page.section(:incorrect_section, '.section') }
      let(:message) do
        "You should provide descendant of SitePrism::Section \
class or/and a block as the second argument."
      end

      it 'raises an ArgumentError' do
        expect { section }.to raise_error(ArgumentError).with_message(message)
      end
    end
  end

  describe 'default search arguments' do
    class PageWithSectionWithDefaultSearchArguments < SitePrism::Page
      class SectionWithDefaultArguments < SitePrism::Section
        set_default_search_arguments :css, '.section'
      end

      class SectionWithDefaultArgumentsForParent < SectionWithDefaultArguments
      end

      section :section_using_defaults, SectionWithDefaultArguments
      section :section_using_defaults_from_parent,
              SectionWithDefaultArgumentsForParent
      section :section_with_locator,
              SectionWithDefaultArguments,
              '.other-section'
      sections :sections, SectionWithDefaultArguments
    end
    let(:page) { PageWithSectionWithDefaultSearchArguments.new }
    let(:search_arguments) { [:css, '.section'] }

    context 'search arguments are provided during the DSL definition' do
      let(:search_arguments) { ['.other-section'] }

      it 'returns the search arguments for a section' do
        expect(page).to receive(:_find).with(*search_arguments, **dont_wait)

        page.section_with_locator
      end
    end

    context 'search arguments are not provided during the DSL definition' do
      context 'default search arguments are set on both parent and section' do
        it 'returns the default search arguments set on the section' do
          expect(page).to receive(:_find).with(*search_arguments, **dont_wait)

          page.section_using_defaults
        end
      end

      context 'default search arguments are only set on the parent section' do
        it 'returns the default search arguments set on the parent section' do
          expect(page).to receive(:_find).with(*search_arguments, **dont_wait)

          page.section_using_defaults_from_parent
        end
      end

      context 'default search arguments are not set on parent or section' do
        let(:invalid_page) do
          class ErroredPage < SitePrism::Page
            section :section, Section
          end
        end
        let(:error_message) do
          "You should provide search arguments in section creation or \
set_default_search_arguments within section class"
        end

        it 'raises an ArgumentError' do
          expect { invalid_page }
            .to raise_error(ArgumentError)
            .with_message(error_message)
        end
      end
    end
  end

  it { is_expected.to respond_to(*Capybara::Session::DSL_METHODS) }
end

describe SitePrism::Section do
  let(:section_without_block) { SitePrism::Section.new(Page.new, locator) }
  let!(:locator) { instance_double('Capybara::Node::Element') }
  let(:section_with_block) do
    SitePrism::Section.new(Page.new, locator) { 1 + 1 }
  end
  let(:dont_wait) { { wait: false } }

  describe '.default_search_arguments' do
    class BaseSection < SitePrism::Section
      set_default_search_arguments :css, 'a.b'
    end

    class ChildSection < BaseSection
      set_default_search_arguments :xpath, '//h3'
    end

    class OtherChildSection < BaseSection; end

    it 'is nil by default' do
      expect(Section.default_search_arguments).to be_nil
    end

    it 'returns the default search arguments' do
      expect(BaseSection.default_search_arguments).to eq([:css, 'a.b'])
    end

    context 'both parent and child class have default_search_arguments' do
      it 'returns the child level arguments' do
        expect(ChildSection.default_search_arguments).to eq([:xpath, '//h3'])
      end
    end

    context 'only parent class has default_search_arguments' do
      it 'returns the parent level arguments' do
        expect(OtherChildSection.default_search_arguments).to eq([:css, 'a.b'])
      end
    end
  end

  describe '.set_default_search_arguments' do
    it { expect(Section).to respond_to(:set_default_search_arguments) }
  end

  describe '#new' do
    class NewSection < SitePrism::Section; end

    class NewPage < SitePrism::Page
      section :new_section, NewSection, '.class-one', css: '.my-css', text: 'Hi'
      element :new_element, '.class-two'
    end

    let(:page) { NewPage.new }

    context 'with a block given' do
      it 'passes the locator to Capybara.within' do
        expect(Capybara).to receive(:within).with(locator)

        section_with_block
      end
    end

    context 'without a block given' do
      it 'does not pass the locator to Capybara.within' do
        expect(Capybara).not_to receive(:within)

        section_without_block
      end
    end

    context 'with Capybara query arguments' do
      let(:query_args) { { css: '.my-css', text: 'Hi' } }
      let(:locator_args) { '.class-one' }

      it 'passes in a hash of query arguments' do
        expect(page)
          .to receive(:_find)
          .with(*locator_args, **query_args, **dont_wait)

        page.new_section
      end
    end

    context 'without Capybara query arguments' do
      let(:query_args) { {} }
      let(:locator_args) { '.class-two' }

      it 'passes in an empty hash, which is then sanitized out' do
        expect(page).to receive(:_find).with(*locator_args, **dont_wait)

        page.new_element
      end
    end
  end

  describe '#visible?' do
    it 'delegates through root_element' do
      expect(locator).to receive(:visible?)

      section_without_block.visible?
    end
  end

  describe '#text' do
    it 'delegates through root_element' do
      expect(locator).to receive(:text)

      section_without_block.text
    end
  end

  describe '#native' do
    it 'delegates through root_element' do
      expect(locator).to receive(:native)

      section_without_block.native
    end
  end

  describe '#execute_script' do
    it 'delegates through Capybara' do
      expect(Capybara.current_session)
        .to receive(:execute_script)
        .with('JUMP!')

      section_without_block.execute_script('JUMP!')
    end
  end

  describe '#evaluate_script' do
    it 'delegates through Capybara' do
      expect(Capybara.current_session)
        .to receive(:evaluate_script)
        .with('How High?')

      section_without_block.evaluate_script('How High?')
    end
  end

  it 'responds to Capybara methods' do
    expect(section_without_block).to respond_to(*Capybara::Session::DSL_METHODS)
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
  end

  describe '#page' do
    subject { SitePrism::Section.new('parent', root_element).page }

    let(:root_element) { 'root' }

    it { is_expected.to eq('root') }

    context 'when root element is nil' do
      let(:root_element) { nil }

      before do
        allow(Capybara)
          .to receive(:current_session)
          .and_return('current session')
      end

      it { is_expected.to eq('current session') }
    end
  end
end
