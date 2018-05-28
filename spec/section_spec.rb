# frozen_string_literal: true

require 'spec_helper'

class Section < SitePrism::Section; end
class Page < SitePrism::Page; end

describe SitePrism::Page do
  describe '.section' do
    it 'should be callable' do
      expect(SitePrism::Page).to respond_to(:section)
    end

    describe '.section with class and block' do
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
        allow(subject).to receive(:find_first).and_return(:element)
      end

      it 'should be an instance of provided section class' do
        expect(subject.section_with_a_block.class.ancestors).to include(SingleSection)
      end

      it 'should have elements from the base section' do
        expect(subject.section_with_a_block).to respond_to(:single_section_element)
      end

      it 'should have elements from the block' do
        expect(subject.section_with_a_block).to respond_to(:block_element)
      end
    end

    context 'second argument is a Class' do
      class PageWithSection < SitePrism::Page
        section :section, Section, '.section'
      end

      subject { PageWithSection.new }

      it { is_expected.to respond_to(:section) }
      it { is_expected.to respond_to(:has_section?) }
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
    end

    context 'second argument is not a Class and no block given' do
      subject { Page.section(:incorrect_section, '.section') }
      let(:message) do
        'You should provide descendant of SitePrism::Section class or/and a block as the second argument.'
      end

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError).with_message(message)
      end
    end

    context 'default search arguments' do
      class PageWithSectionWithDefaultSearchArguments < SitePrism::Page
        class SectionWithDefaultArguments < SitePrism::Section
          set_default_search_arguments :css, '.section'
        end

        class SectionWithDefaultArgumentsForParent < SectionWithDefaultArguments; end

        section  :section_using_defaults,             SectionWithDefaultArguments
        section  :section_using_defaults_from_parent, SectionWithDefaultArgumentsForParent
        section  :section_with_locator,               SectionWithDefaultArguments, '.other-section'
        sections :sections,                           SectionWithDefaultArguments
      end
      let(:page) { PageWithSectionWithDefaultSearchArguments.new }

      context 'when search arguments provided during the section definition' do
        let(:search_arguments) { ['.other-section', {}] }

        it 'returns the search arguments for a section' do
          expect(page).to receive(:find_first).with(*search_arguments)
          page.section_with_locator
        end
      end

      context 'with default search arguments but without search arguments' do
        let(:search_arguments) { [:css, '.section', {}] }

        it 'returns the default search arguments for a section' do
          expect(page).to receive(:find_first).with(*search_arguments)
          page.section_using_defaults
        end
      end

      context 'with default search arguments defined in the parent section but without search arguments' do
        let(:search_arguments) { [:css, '.section', {}] }

        it 'returns the default search arguments for the parent section' do
          expect(page).to receive(:find_first).with(*search_arguments)
          page.section_using_defaults_from_parent
        end
      end

      context 'with niether default search arguments nor search arguments provided' do
        it 'should raise ArgumentError' do
          expect do
            class ErroredPage < SitePrism::Page
              section :section, Section
            end
          end.to raise_error(
            ArgumentError,
            "You should provide search arguments in section creation or \
set_default_search_arguments within section class"
          )
        end
      end
    end
  end
end

describe SitePrism::Section do
  let(:section_without_block) { SitePrism::Section.new(Page.new, locator) }
  let(:locator) { instance_double('Capybara::Node::Element') }
  let(:section_with_block) { SitePrism::Section.new(Page.new, locator) { 1 + 1 } }

  describe '#default_search_arguments' do
    class BaseSection < SitePrism::Section
      set_default_search_arguments :css, '.default'
    end

    class ChildSection < BaseSection
      set_default_search_arguments :xpath, '//html'
    end

    class SecondChildSection < BaseSection; end

    it 'should be nil by default' do
      expect(Section.default_search_arguments).to be_nil
    end

    it { expect(Section).to respond_to(:set_default_search_arguments) }

    it 'should return default search arguments' do
      expect(BaseSection.default_search_arguments).to eql([:css, '.default'])
    end

    it "should return only this section's default search arguments if they are set" do
      expect(ChildSection.default_search_arguments).to eql([:xpath, '//html'])
    end

    it "should return parent section's default search arguments if defaults are not set" do
      expect(SecondChildSection.default_search_arguments).to eql([:css, '.default'])
    end
  end

  describe 'Object' do
    subject { SitePrism::Section }

    it { is_expected.to respond_to(:element) }
    it { is_expected.to respond_to(:elements) }
    it { is_expected.to respond_to(:section) }
    it { is_expected.to respond_to(:sections) }
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

        section_without_block
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
      expect(Capybara.current_session).to receive(:execute_script).with('JUMP!')

      section_without_block.execute_script('JUMP!')
    end
  end

  describe '#evaluate_script' do
    it 'delegates through Capybara' do
      expect(Capybara.current_session).to receive(:evaluate_script).with('How High?')

      section_without_block.evaluate_script('How High?')
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
    subject { SitePrism::Section.new('parent', root_element).page }

    let(:root_element) { 'root' }

    it { is_expected.to eq('root') }

    context 'when root element is nil' do
      let(:root_element) { nil }

      before { allow(Capybara).to receive(:current_session).and_return('current session') }

      it { is_expected.to eq('current session') }
    end
  end
end
