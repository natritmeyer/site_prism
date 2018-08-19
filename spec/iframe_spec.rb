# frozen_string_literal: true

require 'spec_helper'

describe 'iFrame' do
  class Page < SitePrism::Page; end
  let!(:locator) { instance_double('Capybara::Node::Element') }

  shared_examples 'iFrame' do
    let(:error_message) do
      'You can only use iFrames in a block context - Please pass in a block.'
    end

    it 'cannot be called out of block context' do
      expect { subject.iframe }
        .to raise_error(SitePrism::BlockMissingError)
        .with_message(error_message)
    end
  end

  context 'with css elements' do
    class IFrame < SitePrism::Page; end

    class PageCSS2 < SitePrism::Page
      iframe :iframe, IFrame, 'a.b c.d'
    end

    subject { page }
    let(:page) { PageCSS2.new }
    let(:klass) { PageCSS2 }

    it_behaves_like 'iFrame'
  end

  context 'with xpath elements' do
    class IFrame < SitePrism::Page; end

    class PageXPath2 < SitePrism::Page
      iframe :iframe, IFrame, '//w[@class="x"]//y[@class="z"]'
    end

    subject { page }
    let(:page) { PageXPath2.new }
    let(:klass) { PageXPath2 }

    it_behaves_like 'iFrame'
  end

  describe 'A Page with an iFrame contained within' do
    class IframePage < SitePrism::Page
      element :a, '.some_element'
    end

    class PageWithIframe < SitePrism::Page
      iframe :frame, IframePage, '.iframe'
    end

    let(:page) { PageWithIframe.new }

    it 'uses #within_frame delegated through Capybara.current_session' do
      expect(Capybara.current_session)
        .to receive(:within_frame)
        .with(:css, '.iframe')
        .and_yield

      expect_any_instance_of(IframePage)
        .to receive(:_find)
        .with('.some_element')
        .and_return(locator)

      page.frame(&:a)
    end
  end

  describe 'A Section with an iFrame contained within' do
    class IframePage < SitePrism::Page
      element :a, '.some_element'
    end

    class SectionWithIframe < SitePrism::Section
      iframe :frame, IframePage, '.iframe'
    end

    let(:section) { SectionWithIframe.new(Page.new, locator) }

    it 'uses #within_frame delegated through Capybara.current_session' do
      expect(Capybara.current_session)
        .to receive(:within_frame)
        .with(:css, '.iframe')
        .and_yield

      expect_any_instance_of(IframePage)
        .to receive(:_find)
        .with('.some_element')
        .and_return(locator)

      section.frame(&:a)
    end
  end
end
