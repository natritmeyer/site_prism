require 'spec_helper'

describe SitePrism::Page do
  it 'should respond to section' do
    expect(SitePrism::Page).to respond_to :section
  end

  describe '.section' do
    context 'second argument is a Class' do
      it 'should create a method' do
        class SomeSection < SitePrism::Section
        end

        class PageWithSection < SitePrism::Page
          section :bob, SomeSection, '.bob'
        end

        page = PageWithSection.new
        expect(page).to respond_to :bob
      end

      it 'should create a matching existence method for a section' do
        class SomePageWithSectionThatNeedsTestingForExistence < SitePrism::Section
        end

        class YetAnotherPageWithASection < SitePrism::Page
          section :something, SomePageWithSectionThatNeedsTestingForExistence, '.bob'
        end

        page = YetAnotherPageWithASection.new
        expect(page).to respond_to :has_something?
      end
    end

    context 'second argument is not a Class and a block given' do
      context 'block given' do
        it 'should create an anonymous section with the block' do
          class PageWithSection < SitePrism::Page
            section :anonymous_section, '.section' do |s|
              s.element :title, 'h1'
            end
          end

          page = PageWithSection.new
          expect(page).to respond_to :anonymous_section
        end
      end
    end

    context 'second argument is not a class and no block given' do
      it 'should raise an ArgumentError' do
        class Page < SitePrism::Page
        end
        expect { Page.section :incorrect_section, '.section' }.to raise_error ArgumentError, 'You should provide section class either as a block, or as the second argument'
      end
    end
  end
end

describe SitePrism::Section do
  it 'should respond to element' do
    expect(SitePrism::Section).to respond_to :element
  end

  it 'should respond to elements' do
    expect(SitePrism::Section).to respond_to :elements
  end

  it 'should respond to javascript methods' do
    class JsSection < SitePrism::Section
    end

    page = PageWithSection.new

    expect(JsSection.new(page, 'a')).to respond_to :execute_script
    expect(JsSection.new(page, 'a')).to respond_to :evaluate_script
  end
end
