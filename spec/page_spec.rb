# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  class PageWithNoUrl < SitePrism::Page; end
  class PageWithUrl < SitePrism::Page
    set_url '/bob'
  end
  class PageWithUriTemplate < SitePrism::Page
    set_url '/users{/username}{?query*}'
  end

  let(:page_with_no_url) { PageWithNoUrl.new }
  let(:page_with_url) { PageWithUrl.new }
  let(:page_with_uri_template) { PageWithUriTemplate.new }

  before do
    allow(SitePrism::Waiter).to receive(:default_wait_time).and_return(0)
  end

  it 'responds to section' do
    expect(SitePrism::Page).to respond_to(:section)
  end

  it 'responds to sections' do
    expect(SitePrism::Page).to respond_to(:sections)
  end

  it 'responds to element' do
    expect(SitePrism::Page).to respond_to(:element)
  end

  it 'responds to elements' do
    expect(SitePrism::Page).to respond_to(:elements)
  end

  it 'responds to set_url' do
    expect(SitePrism::Page).to respond_to(:set_url)
  end

  it 'responds to set_url_matcher' do
    expect(SitePrism::Page).to respond_to(:set_url_matcher)
  end

  it 'should be able to set a url against it' do
    expect(page_with_url.url).to eq('/bob')
  end

  it 'url should be nil by default' do
    expect(page_with_no_url.url).to be_nil
  end

  describe 'loaded?' do
    subject { PageWithUrl.new }

    it 'when page is loaded' do
      allow(subject).to receive(:displayed?).and_return true

      expect(subject).to be_loaded
    end

    it 'when page is not loaded' do
      allow(subject).to receive(:displayed?).and_return false

      expect(subject).not_to be_loaded
    end
  end

  describe '#load' do
    it "should not allow loading if the url hasn't been set" do
      expect { page_with_no_url.load }
        .to raise_error(SitePrism::NoUrlForPage)
    end

    it 'should allow loading if the url has been set' do
      expect { page_with_url.load }.not_to raise_error
    end

    it 'should allow expansions if the url has them' do
      expect { page_with_uri_template.load(username: 'foobar') }.not_to raise_error

      expect(page_with_uri_template.url(username: 'foobar', query: { 'recent_posts' => 'true' }))
        .to eq('/users/foobar?recent_posts=true')

      expect(page_with_uri_template.url).to eq('/users')
    end

    it 'should allow to load html' do
      expect { page_with_url.load('<html/>') }.not_to raise_error
    end

    context 'when passed a block' do
      class PageWithLoadValidations < SitePrism::Page
        set_url '/foo_page'

        def must_be_true
          true
        end

        def also_true
          true
        end

        def foo?
          true
        end

        load_validation { [must_be_true, 'It is not true!'] }
        load_validation { [also_true, 'It is not also true!'] }
      end

      let(:page_with_load_validations) { PageWithLoadValidations.new }

      it 'should allow to load html and yields itself' do
        expect(page_with_no_url.load('<html>hi<html/>', &:text)).to eq('hi')
      end

      context 'With Passing Load Validations' do
        it 'executes the block' do
          expect(page_with_load_validations.load { :return_this }).to eq(:return_this)
        end

        it 'yields itself to the passed block' do
          expect(page_with_load_validations).to receive(:foo?).and_call_original

          page_with_load_validations.load(&:foo?)
        end
      end

      context 'With Failing Load Validations' do
        it 'raises an error' do
          allow(page_with_load_validations).to receive(:must_be_true).and_return(false)

          expect { page_with_load_validations.load { puts 'foo' } }
            .to raise_error(SitePrism::NotLoadedError, /It is not true!/)
        end
      end
    end
  end

  it 'url matcher should be nil by default' do
    expect(PageWithNoUrl.url_matcher).to be_nil

    expect(page_with_no_url.url_matcher).to be_nil
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

  describe 'with a bogus URL matcher' do
    class PageWithBogusFullUrlMatcher < SitePrism::Page
      set_url_matcher this: "isn't a URL matcher"
    end

    let(:page) { PageWithBogusFullUrlMatcher.new }

    specify '#url_matches raises InvalidUrlMatcher' do
      expect { page.url_matches }
        .to raise_error(SitePrism::InvalidUrlMatcher)
        .with_message('Could not automatically match your URL. Templated port numbers are unsupported.')
    end

    specify '#displayed? raises InvalidUrlMatcher' do
      expect { page.displayed? }
        .to raise_error(SitePrism::InvalidUrlMatcher)
        .with_message('Could not automatically match your URL. Templated port numbers are unsupported.')
    end
  end

  describe 'with a full string URL matcher' do
    class PageWithStringFullUrlMatcher < SitePrism::Page
      set_url_matcher 'https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment'
    end

    let(:page) { PageWithStringFullUrlMatcher.new }

    it 'matches with all elements matching' do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be true
    end

    it "doesn't match with a non-matching fragment" do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#otherfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with a missing param" do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong path" do
      swap_current_url('https://joe:bump@bla.org:443/not_foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong host" do
      swap_current_url('https://joe:bump@blabber.org:443/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong user" do
      swap_current_url('https://joseph:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong password" do
      swap_current_url('https://joe:bean@bla.org:443/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong scheme" do
      swap_current_url('http://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end

    it "doesn't match with wrong port" do
      swap_current_url('https://joe:bump@bla.org:8000/foo?bar=baz&bar=boof#myfragment')

      expect(page.displayed?).to be false
    end
  end

  context 'with a minimal URL matcher' do
    class PageWithStringMinimalUrlMatcher < SitePrism::Page
      set_url_matcher '/foo'
    end

    let(:page) { PageWithStringMinimalUrlMatcher.new }

    it 'matches a complex URL by only path' do
      swap_current_url('https://joe:bump@bla.org:443/foo?bar=baz&bar=boof#myfragment')
      expect(page.displayed?).to be true
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

      expect(page.displayed?).to be true
    end
  end

  context 'with a parameterized URL matcher' do
    class PageWithParameterizedUrlMatcher < SitePrism::Page
      set_url_matcher '{scheme}:///foos{/id}'
    end

    let(:page) { PageWithParameterizedUrlMatcher.new }

    describe '#displayed?' do
      it 'returns true without expected_mappings provided' do
        swap_current_url('http://localhost:3000/foos/28')

        expect(page.displayed?).to be true
      end

      it 'returns true with correct expected_mappings provided' do
        swap_current_url('http://localhost:3000/foos/28')

        expect(page.displayed?(id: 28)).to be true
      end

      it 'returns false with incorrect expected_mappings provided' do
        swap_current_url('http://localhost:3000/foos/28')

        expect(page.displayed?(id: 17)).to be false
      end
    end

    it 'passes through incorrect expected_mappings from the be_displayed matcher' do
      swap_current_url('http://localhost:3000/foos/28')

      expect(page).not_to be_displayed(id: 17)
    end

    it 'passes through correct expected_mappings from the be_displayed matcher' do
      swap_current_url('http://localhost:3000/foos/28')

      expect(page).to be_displayed(id: 28)
    end

    describe '#url_matches' do
      it 'returns mappings from the current_url' do
        swap_current_url('http://localhost:3000/foos/15')

        expect(page.url_matches).to eq('scheme' => 'http', 'id' => '15')
      end

      it "returns nil if current_url doesn't match the url_matcher" do
        swap_current_url('http://localhost:3000/bars/15')

        expect(page.url_matches).to be_nil
      end
    end
  end

  describe 'with a regexp matcher' do
    class PageWithRegexpUrlMatcher < SitePrism::Page
      set_url_matcher(/foos\/(\d+)/)
    end

    let(:page) { PageWithRegexpUrlMatcher.new }

    describe '#url_matches' do
      it 'returns regexp MatchData' do
        swap_current_url('http://localhost:3000/foos/15')

        expect(page.url_matches).to be_kind_of(MatchData)
      end

      it 'lets you get at the captures' do
        swap_current_url('http://localhost:3000/foos/15')

        expect(page.url_matches[1]).to eq '15'
      end

      it "returns nil if current_url doesn't match the url_matcher" do
        swap_current_url('http://localhost:3000/bars/15')

        expect(page.url_matches).to eq nil
      end
    end
  end

  it 'should expose the page title' do
    expect(SitePrism::Page.new).to respond_to :title
  end

  it 'should raise an exception if passing a block to an element' do
    expect { TestHomePage.new.invisible_element { :any_old_block } }
      .to raise_error(SitePrism::UnsupportedBlock)
      .with_message('TestHomePage#invisible_element does not accept blocks, did you mean to define a (i)frame?')
  end

  it 'should raise an exception if passing a block to elements' do
    expect { TestHomePage.new.lots_of_links { :any_old_block } }
      .to raise_error(SitePrism::UnsupportedBlock)
      .with_message('TestHomePage#lots_of_links does not accept blocks, did you mean to define a (i)frame?')
  end

  it 'should raise an exception if passing a block to sections' do
    expect { TestHomePage.new.nonexistent_sections { :any_old_block } }
      .to raise_error(SitePrism::UnsupportedBlock)
      .with_message('TestHomePage#nonexistent_sections does not accept blocks, did you mean to define a (i)frame?')
  end

  def swap_current_url(url)
    allow(page).to receive(:page).and_return(double(current_url: url))
  end
end
