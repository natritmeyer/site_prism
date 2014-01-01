require 'spec_helper'

describe SitePrism::Page do
  it "should respond to section" do
    SitePrism::Page.should respond_to :section
  end

  describe ".section" do
    context "second argument is a Class" do
      it "should create a method" do
        class SomeSection < SitePrism::Section
        end

        class PageWithSection < SitePrism::Page
          section :bob, SomeSection, '.bob'
        end

        page = PageWithSection.new
        page.should respond_to :bob
      end

      it "should create a matching existence method for a section" do
        class SomePageWithSectionThatNeedsTestingForExistence < SitePrism::Section
        end

        class YetAnotherPageWithASection < SitePrism::Page
          section :something, SomePageWithSectionThatNeedsTestingForExistence, '.bob'
        end

        page = YetAnotherPageWithASection.new
        page.should respond_to :has_something?
      end
    end

    context "second argument is not a Class and a block given" do
      context "block given" do
        it "should create an anonymous section with the block" do
          class PageWithSection < SitePrism::Page
            section :anonymous_section, '.section' do |s|
              s.element :title, 'h1'
            end
          end

          page = PageWithSection.new
          page.should respond_to :anonymous_section
        end
      end
    end
  end
end

describe SitePrism::Section do
  it "should respond to element" do
    SitePrism::Section.should respond_to :element
  end

  it "should respond to elements" do
    SitePrism::Section.should respond_to :elements
  end

  it "should respond to javascript methods" do
    class JsSection < SitePrism::Section
    end

    page = PageWithSection.new

    JsSection.new(page, "a").should respond_to :execute_script
    JsSection.new(page, "a").should respond_to :evaluate_script
  end
end

