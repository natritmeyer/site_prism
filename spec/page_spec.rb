require 'spec_helper'

describe SitePrism::Page do
  it "should respond to load" do
    SitePrism::Page.new.should respond_to :load
  end

  it "should respond to set_url" do
    SitePrism::Page.should respond_to :set_url
  end

  it "should be able to set a url against it" do
    class PageToSetUrlAgainst < SitePrism::Page
      set_url "bob"
    end
    page = PageToSetUrlAgainst.new
    page.url.should == "bob"
  end

  it "url should be nil by default" do
    class PageDefaultUrl < SitePrism::Page; end
    page = PageDefaultUrl.new
    PageDefaultUrl.url.should be_nil
    page.url.should be_nil
  end

  it "should not allow loading if the url hasn't been set" do
    class MyPageWithNoUrl < SitePrism::Page; end
    page_with_no_url = MyPageWithNoUrl.new
    expect { page_with_no_url.load }.to raise_error SitePrism::NoUrlForPage
  end

  it "should allow loading if the url has been set" do
    class MyPageWithUrl < SitePrism::Page
      set_url "bob"
    end
    page_with_url = MyPageWithUrl.new
    expect { page_with_url.load }.to_not raise_error SitePrism::NoUrlForPage
  end

  it "should respond to set_url_matcher" do
    SitePrism::Page.should respond_to :set_url_matcher
  end

  it "url matcher should be nil by default" do
    class PageDefaultUrlMatcher < SitePrism::Page; end
    page = PageDefaultUrlMatcher.new
    PageDefaultUrlMatcher.url_matcher.should be_nil
    page.url_matcher.should be_nil
  end

  it "should be able to set a url matcher against it" do
    class PageToSetUrlMatcherAgainst < SitePrism::Page
      set_url_matcher /bob/
    end
    page = PageToSetUrlMatcherAgainst.new
    page.url_matcher.should == /bob/
  end

  it "should raise an exception if displayed? is called before the matcher has been set" do
    class PageWithNoMatcher < SitePrism::Page; end
    expect { PageWithNoMatcher.new.displayed? }.to raise_error SitePrism::NoUrlMatcherForPage
  end

  it "should allow calls to displayed? if the url matcher has been set" do
    class PageWithUrlMatcher < SitePrism::Page
      set_url_matcher /bob/
    end
    page = PageWithUrlMatcher.new
    expect { page.displayed? }.to_not raise_error SitePrism::NoUrlMatcherForPage
  end

  it "should expose the page title" do
    SitePrism::Page.new.should respond_to :title
  end
end

