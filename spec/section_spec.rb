require 'spec_helper'

describe SitePrism::Page do
  it "should respond to section" do
    SitePrism::Page.should respond_to :section
  end

  it "section method should create a method" do
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

    JsSection.new("a", page).should respond_to :execute_script
    JsSection.new("a", page).should respond_to :evaluate_script
  end
end

