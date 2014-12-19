require 'spec_helper'

describe SitePrism::Page do
  it 'should respond to element' do
    expect(SitePrism::Page).to respond_to :element
  end

  it 'element method should generate existence check method' do
    class PageWithElement < SitePrism::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_bob?
  end

  it 'element method should generate method to return the element' do
    class PageWithElement < SitePrism::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithElement.new
    expect(page).to respond_to :bob
  end

  it 'element method without css should generate existence check method' do
    class PageWithElement < SitePrism::Page
      element :thing, 'input#nonexistent'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_no_thing?
  end

  it 'should be able to wait for an element' do
    class PageWithElement < SitePrism::Page
      element :some_slow_element, 'a.slow'
    end
    page = PageWithElement.new
    expect(page).to respond_to :wait_for_some_slow_element
  end

  it 'should know if all mapped elements are on the page' do
    class PageWithAFewElements < SitePrism::Page
      element :bob, 'a.b c.d'
    end
    page = PageWithAFewElements.new
    expect(page).to respond_to :all_there?
  end

  it 'should exclude elements from all_there if defined' do
    class PageWithAFewElements < SitePrism::Page
      element :bob, 'a.b c.d'
      section :jills_modal, '#xyzz' do
        element :modal_input, '#modal_input'
      end
      section :zanes_modal, '#zzxx' do
        element :modal_date_picker, '#modal_date_picker'
      end

      def excluded_elements
        %w(jills_modal zanes_modal)
      end
    end
    page = PageWithAFewElements.new
    allow(page).to receive(:has_bob?).and_return(true)
    allow(page).to receive(:has_jills_modal?).and_return(false)
    allow(page).to receive(:has_zanes_modal?).and_return(false)
    page.all_there?
    expect(page).to have_received(:has_bob?).at_least(:once)
    expect(page).to_not have_received(:has_jills_modal?)
    expect(page).to_not have_received(:has_zanes_modal?)
  end

  it 'element method with xpath should generate existence check method' do
    class PageWithElement < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :has_bob?
  end

  it 'element method with xpath should generate method to return the element' do
    class PageWithElement < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :bob
  end

  it 'should be able to wait for an element defined with xpath selector' do
    class PageWithElement < SitePrism::Page
      element :some_slow_element, :xpath, '//a[@class="slow"]'
    end
    page = PageWithElement.new
    expect(page).to respond_to :wait_for_some_slow_element
  end

  it 'should know if all mapped elements defined by xpath selector are on the page' do
    class PageWithAFewElements < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
    end
    page = PageWithAFewElements.new
    expect(page).to respond_to :all_there?
  end
end
