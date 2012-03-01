require 'spec_helper'

describe SitePrism::Page do
  it "should respond to elements" do
    SitePrism::Page.should respond_to :elements
  end

  it "elements method should generate existence check method" do
    class PageWithElements < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    page.should respond_to :has_bobs?
  end

  it "elements method hould generate method to return the elements" do
    class PageWithElements < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    page.should respond_to :bobs
  end
end

