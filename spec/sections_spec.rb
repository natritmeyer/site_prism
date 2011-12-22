require 'spec_helper'

describe Prismatic::Page do
  it "should respond to sections" do
    Prismatic::Page.should respond_to :sections
  end
  
  it "should create a matching existence method for sections" do
    class SomePageWithSectionsThatNeedsTestingForExistence < Prismatic::Section
    end
    
    class YetAnotherPageWithSections < Prismatic::Page
      section :some_things, SomePageWithSectionsThatNeedsTestingForExistence, '.bob'
    end
    
    page = YetAnotherPageWithSections.new
    page.should respond_to :has_some_things?
  end
end