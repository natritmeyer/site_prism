# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  class PageWithElement < SitePrism::Page
    element :bob, 'a.b c.d'
  end

  let(:page) { PageWithElement.new }

  it 'should respond to element' do
    expect(SitePrism::Page).to respond_to(:element)
  end

  it 'element method should generate existence check method' do
    expect(page).to respond_to(:has_bob?)
  end

  it 'element method should generate method to return the element' do
    expect(page).to respond_to(:bob)
  end

  it 'element method should generate non-existence check method' do
    expect(page).to respond_to(:has_no_bob?)
  end

  it 'should know if all mapped elements are on the page' do
    expect(page).to respond_to(:all_there?)
  end

  it 'should be able to wait for an element' do
    expect(page).to respond_to(:wait_for_bob)
  end

  it 'should be able to wait for an element to not exist' do
    expect(page).to respond_to(:wait_for_no_bob)
  end

  describe '#expected_elements' do
    class PageWithAFewElements < SitePrism::Page
      element :bob, 'a.b c.d'
      element :success_msg, 'span.alert-success'

      expected_elements :bob
    end

    let(:page) { PageWithAFewElements.new }

    before do
      allow(page).to receive(:has_bob?).and_return(true)
      allow(page).to receive(:has_success_msg?).and_return(false)
    end

    it 'allows for a successful all_there? check' do
      expect(page.all_there?).to be_truthy
    end

    it 'checks only the expected elements' do
      page.all_there?
      expect(page).to have_received(:has_bob?).at_least(:once)
      expect(page).not_to have_received(:has_success_msg?)
    end
  end

  context 'with xpath selector' do
    class PageWithElement < SitePrism::Page
      element :bob, :xpath, '//a[@class="b"]//c[@class="d"]'
    end

    let(:page) { PageWithElement.new }

    it 'element method should generate existence check method' do
      expect(page).to respond_to(:has_bob?)
    end

    it 'element method should generate method to return the element' do
      expect(page).to respond_to(:bob)
    end

    it 'should know if all mapped elements defined are on the page' do
      expect(page).to respond_to(:all_there?)
    end

    it 'should be able to wait for an element' do
      expect(page).to respond_to(:wait_for_bob)
    end

    it 'should be able to wait for an element to not exist' do
      expect(page).to respond_to(:wait_for_no_bob)
    end
  end
end
