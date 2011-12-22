require 'spec_helper'

describe Prismatic::Page do
  it "should respond to section" do
    Prismatic::Page.should respond_to :section
  end
  
  it "section method should create a method" do
    class SomeSection < Prismatic::Section
    end
    
    class PageWithSection < Prismatic::Page
      section :bob, SomeSection, '.bob'
    end
    
    page = PageWithSection.new
    page.should respond_to :bob
  end
  
  it "should create a matching existence method for a section" do
    class SomePageWithSectionThatNeedsTestingForExistence < Prismatic::Section
    end
    
    class YetAnotherPageWithASection < Prismatic::Page
      section :something, SomePageWithSectionThatNeedsTestingForExistence, '.bob'
    end
    
    page = YetAnotherPageWithASection.new
    page.should respond_to :has_something?
  end
end

describe Prismatic::Section do
  it "should respond to element" do
    Prismatic::Section.should respond_to :element
  end
  
  it "should respond to elements" do
    Prismatic::Section.should respond_to :elements
  end
end