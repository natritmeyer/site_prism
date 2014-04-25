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
  let(:a_page) { class Page < SitePrism::Page; end }

  it "should respond to element" do
    expect(SitePrism::Section).to respond_to :element
  end

  it 'should respond to elements' do
    expect(SitePrism::Section).to respond_to :elements
  end

  it 'passes a given block to Capybara.within' do
    expect(Capybara).to receive(:within).with('div')
    SitePrism::Section.new(a_page, 'div') { 1+1 }
  end

  it 'does not require a block' do
    expect(Capybara).to_not receive(:within)
    SitePrism::Section.new(a_page, 'div')
  end

  describe 'instance' do
    subject(:section) { SitePrism::Section.new('parent', 'locator') }

    it "responds to javascript methods" do
      expect(section).to respond_to :execute_script
      expect(section).to respond_to :evaluate_script
    end
  end
end
