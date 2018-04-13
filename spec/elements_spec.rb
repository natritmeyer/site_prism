# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Page do
  subject { Page.new }

  class Page < SitePrism::Page
    elements :bobs, 'a.b c.d'
  end

  context 'with elements `bobs` defined' do
    it { is_expected.to respond_to(:bobs) }
    it { is_expected.to respond_to(:has_bobs?) }
  end
end
