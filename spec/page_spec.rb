require 'spec_helper'

describe Prismatic::Page do
  it "should respond to load" do
    Prismatic::Page.new.should respond_to :load
  end
  
  it "should respond to set_url" do
    Prismatic::Page.should respond_to :set_url
  end
  
  it "should be able to set a url against it" do
    class MyPage < Prismatic::Page
      set_url "bob"
    end
    my_page = MyPage.new
    my_page.url.should == "bob"
  end
end