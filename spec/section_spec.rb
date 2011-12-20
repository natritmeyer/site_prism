require 'spec_helper'

describe Prismatic::Page do
  it "should respond to section" do
    Prismatic::Page.should respond_to :section
  end
  
  it "section method should create a method and return a section" do
    class SomeSection < Prismatic::Section
    end
    
    class PageWithSection < Prismatic::Page
      section :bob, SomeSection, '.bob'
    end
    
    page = PageWithSection.new
    page.should respond_to :bob
    page.bob.should be_a_kind_of Prismatic::Section
  end
end