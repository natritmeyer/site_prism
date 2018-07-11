# frozen_string_literal: true

require 'spec_helper'

describe 'iFrame' do
  shared_examples 'iFrame' do
    let(:error_message) do
      'You can only use iFrames in a block context. See docs for more details.'
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
end
