require 'spec_helper'

describe Prismatic::Page do
  it "should respond to load" do
    Prismatic::Page.new.should respond_to :load
  end
  
  it "should respond to set_url" do
    Prismatic::Page.should respond_to :set_url
  end
  
  it "should be able to set a url against it" do
    class PageToSetUrlAgainst < Prismatic::Page
      set_url "bob"
    end
    page = PageToSetUrlAgainst.new
    page.url.should == "bob"
  end
  
  it "url should be nil by default" do
    class PageDefaultUrl < Prismatic::Page; end
    page = PageDefaultUrl.new
    PageDefaultUrl.url.should be_nil
    page.url.should be_nil
  end
  
  it "should not allow loading if the url hasn't been set" do
    class MyPageWithNoUrl < Prismatic::Page; end
    page_with_no_url = MyPageWithNoUrl.new
    expect { page_with_no_url.load }.to raise_error Prismatic::NoUrlForPage
  end
  
  it "should allow loading if the url has been set" do
    class MyPageWithUrl < Prismatic::Page
      set_url "bob"
    end
    page_with_url = MyPageWithUrl.new
    expect { page_with_url.load }.to_not raise_error Prismatic::NoUrlForPage
  end
end