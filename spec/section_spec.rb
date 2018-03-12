# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  describe '.section' do
    class Section < SitePrism::Section; end

    class PageWithAnonymousSection < SitePrism::Page
      section :anonymous_section, '.section' do |s|
        s.element :title, 'h1'
      end
    end

    class PageWithSection < SitePrism::Page
      section :section, Section, '.section'
    end

    context 'second argument is a Class' do
      subject { PageWithSection.new }

      it 'should create a section using the Class' do
        expect(subject).to respond_to(:section)
      end
    end

    context 'second argument is not a Class and a block given' do
      subject { PageWithAnonymousSection.new }

      it 'should create an anonymous section using the block' do
        expect(subject).to respond_to(:anonymous_section)
      end
    end

    context 'second argument is not a Class and no block given' do
      subject { Page.section(:incorrect_section, '.section') }
      let(:error_message) do
        'You should provide section class either as a block, or as the second argument.'
      end

      it 'should raise an ArgumentError' do
        class Page < SitePrism::Page; end

        expect { subject }
          .to raise_error(ArgumentError)
          .with_message(error_message)
      end
    end
  end
end

describe SitePrism::Section do
  subject { SitePrism::Section.new(page, locator) }
  let(:locator) { object_double(Capybara::Node::Element.new(:foo, :bar, :baz, :ignore)) }
  let(:page) { class Page < SitePrism::Page; end }
  let(:section_with_block) { SitePrism::Section.new(page, locator) { 1 + 1 } }

  it 'responds to element' do
    expect(SitePrism::Section).to respond_to(:element)
  end

  it 'responds to elements' do
    expect(SitePrism::Section).to respond_to(:elements)
  end

  it 'passes a given block to Capybara.within' do
    expect(Capybara).to receive(:within).with(locator)

    section_with_block
  end

  it 'does not require a block' do
    expect(Capybara).not_to receive(:within)

    subject
  end

  describe 'instance' do
    it 'evaluates visibility by delegating through root_element' do
      expect(locator).to receive(:visible?)

      subject.visible?
    end

    it 'obtains the text of a section by delegating through root_element' do
      expect(locator).to receive(:text)

      subject.text
    end

    it 'executes scripts using Capybara' do
      expect(Capybara.current_session).to receive(:execute_script).with('JUMP!')

      subject.execute_script('JUMP!')
    end

    it 'evaluates scripts using Capybara' do
      expect(Capybara.current_session).to receive(:evaluate_script).with('How High?')

      subject.evaluate_script('How High?')
    end
  end
end
