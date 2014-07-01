# encoding: utf-8

require 'spec_helper'

describe SitePrism::Page do
  it 'should respond to elements' do
    expect(SitePrism::Page).to respond_to :elements
  end

  it 'elements method should generate existence check method' do
    class PageWithElements < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    expect(page).to respond_to :has_bobs?
  end

  it 'elements method should generate method to return the elements' do
    class PageWithElements < SitePrism::Page
      elements :bobs, 'a.b c.d'
    end
    page = PageWithElements.new
    expect(page).to respond_to :bobs
  end
end
