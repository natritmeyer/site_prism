require 'spec_helper'

describe SitePrism::Page do
  it 'should respond to sections' do
    expect(SitePrism::Page).to respond_to :sections
  end

  it 'should create a matching existence method for sections' do
    class SomePageWithSectionsThatNeedsTestingForExistence < SitePrism::Section
    end

    class YetAnotherPageWithSections < SitePrism::Page
      # in order to test method name collisions with rspec, we'll include its matchers
      include RSpec::Matchers

      section  :some_things,  SomePageWithSectionsThatNeedsTestingForExistence, '.bob'
      sections :other_things, SomePageWithSectionsThatNeedsTestingForExistence, '.tim'
    end

    page = YetAnotherPageWithSections.new
    expect(page).to respond_to :has_some_things?
    expect(page).to respond_to :has_other_things?
    # will throw a NoMethodError if methods overwritten by rspec matchers are called
    expect { page.other_things }.not_to raise_error
  end
end
