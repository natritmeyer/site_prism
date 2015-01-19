require 'spec_helper'

describe SitePrism::Page do
  before do
    allow(SitePrism::Waiter).to receive(:default_wait_time).and_return 0
  end

  it 'should respond to load' do
    expect(SitePrism::Page.new).to respond_to :load
  end

  it 'should respond to set_url' do
    expect(SitePrism::Page).to respond_to :set_url
  end

  it 'should be able to set a url against it' do
    class PageToSetUrlAgainst < SitePrism::Page
      set_url '/bob'
    end
    page = PageToSetUrlAgainst.new
    expect(page.url).to eq('/bob')
  end

  it 'url should be nil by default' do
    class PageDefaultUrl < SitePrism::Page; end
    page = PageDefaultUrl.new
    expect(PageDefaultUrl.url).to be_nil
    expect(page.url).to be_nil
  end

  it "should not allow loading if the url hasn't been set" do
    class MyPageWithNoUrl < SitePrism::Page; end
    page_with_no_url = MyPageWithNoUrl.new
    expect { page_with_no_url.load }.to raise_error
  end

  it 'should allow loading if the url has been set' do
    class MyPageWithUrl < SitePrism::Page
      set_url '/bob'
    end
    page_with_url = MyPageWithUrl.new
    expect { page_with_url.load }.to_not raise_error
  end

  it 'should allow expansions if the url has them' do
    class MyPageWithUriTemplate < SitePrism::Page
      set_url '/users{/username}{?query*}'
    end
    page_with_url = MyPageWithUriTemplate.new
    expect { page_with_url.load(username: 'foobar') }.to_not raise_error
    expect(page_with_url.url(username: 'foobar', query: { 'recent_posts' => 'true' })).to eq('/users/foobar?recent_posts=true')
    expect(page_with_url.url(username: 'foobar')).to eq('/users/foobar')
    expect(page_with_url.url).to eq('/users')
  end

  it 'should allow to load html' do
    class Page < SitePrism::Page; end
    page = Page.new
    expect { page.load('<html/>') }.to_not raise_error
  end

  it 'should respond to set_url_matcher' do
    expect(SitePrism::Page).to respond_to :set_url_matcher
  end

  it 'url matcher should be nil by default' do
    class PageDefaultUrlMatcher < SitePrism::Page; end
    page = PageDefaultUrlMatcher.new
    expect(PageDefaultUrlMatcher.url_matcher).to be_nil
    expect(page.url_matcher).to be_nil
  end

  it 'should be able to set a url matcher against it' do
    class PageToSetUrlMatcherAgainst < SitePrism::Page
      set_url_matcher(/bob/)
    end
    page = PageToSetUrlMatcherAgainst.new
    expect(page.url_matcher).to eq(/bob/)
  end

  it 'should raise an exception if displayed? is called before the matcher has been set' do
    class PageWithNoMatcher < SitePrism::Page; end
    expect { PageWithNoMatcher.new.displayed? }.to raise_error SitePrism::NoUrlMatcherForPage
  end

  it 'should allow calls to displayed? if the url matcher has been set' do
    class PageWithUrlMatcher < SitePrism::Page
      set_url_matcher(/bob/)
    end
    page = PageWithUrlMatcher.new
    expect { page.displayed? }.to_not raise_error
  end

  describe 'with a full string URL matcher' do
    class PageWithStringFullUrlMatcher < SitePrism::Page
      set_url_matcher 'https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment'
    end

    let(:page) { PageWithStringFullUrlMatcher.new }

    it 'matches with all elements matching' do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(true)
    end

    it "doesn't match with a non-matching fragment" do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#otherfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with a missing param" do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong path" do
      swap_current_url('https://joe:bump@bla.org:443/not_foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong host" do
      swap_current_url('https://joe:bump@blabber.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong user" do
      swap_current_url('https://joseph:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong password" do
      swap_current_url('https://joe:bean@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong scheme" do
      swap_current_url('http://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end

    it "doesn't match with wrong port" do
      swap_current_url('https://joe:bump@bla.org:8000/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(false)
    end
  end

  context 'with a minimal URL matcher' do
    class PageWithStringMinimalUrlMatcher < SitePrism::Page
      set_url_matcher '/foo'
    end

    let(:page) { PageWithStringMinimalUrlMatcher.new }

    it 'matches a complex URL by only path' do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to eq(true)
    end
  end

  context 'with an implicit matcher' do
    class PageWithImplicitUrlMatcher < SitePrism::Page
      set_url '/foo'
    end

    let(:page) { PageWithImplicitUrlMatcher.new }

    it 'should default the matcher to the url' do
      expect(page.url_matcher).to eq('/foo')
    end

    it 'matches a realistic local dev URL' do
      swap_current_url('http://localhost:3000/foo')
      expect(page.displayed?).to eq(true)
    end
  end

  it 'should expose the page title' do
    expect(SitePrism::Page.new).to respond_to :title
  end

  it 'should raise exception if passing a block to an element' do
    expect do
      TestHomePage.new.invisible_element do
        puts 'bla'
      end
    end.to raise_error(SitePrism::UnsupportedBlock)
  end

  it 'should raise exception if passing a block to elements' do
    expect do
      TestHomePage.new.lots_of_links do
        puts 'bla'
      end
    end.to raise_error(SitePrism::UnsupportedBlock)
  end

  it 'should raise exception if passing a block to a section' do
    expect do
      TestHomePage.new.people do
        puts 'bla'
      end
    end.to raise_error(SitePrism::UnsupportedBlock)
  end

  it 'should raise exception if passing a block to sections' do
    expect do
      TestHomePage.new.nonexistent_section do
        puts 'bla'
      end
    end.to raise_error(SitePrism::UnsupportedBlock)
  end

  def swap_current_url(url)
    allow(page).to receive(:page).and_return(double(current_url: url))
  end
end
