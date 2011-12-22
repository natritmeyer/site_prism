require 'spec_helper'

describe SitePrism::Page do
  it "should respond to element" do
    SitePrism::Page.should respond_to :element
  end
  
  it "element method should generate existence check method" do
    class PageWithElement < SitePrism::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    page.should respond_to :has_bob?
  end
  
  it "element method hould generate method to return the element" do
    class PageWithElement < SitePrism::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    page.should respond_to :bob
  end
end