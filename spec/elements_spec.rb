require 'spec_helper'

describe Prismatic::Page do
  it "should respond to elements" do
    Prismatic::Page.should respond_to :elements
  end
  
  it "elements method should generate existence check method" do
    class PageWithElements < Prismatic::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    page.should respond_to :has_bobs?
  end
  
  it "elements method hould generate method to return the elements" do
    class PageWithElements < Prismatic::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    page.should respond_to :bobs
  end
end