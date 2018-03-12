# frozen_string_literal: true

require 'spec_helper'

describe 'SitePrism::VERSION' do
  subject { SitePrism::VERSION }

  it { is_expected.to be_truthy }
end
