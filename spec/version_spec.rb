# frozen_string_literal: true

require 'spec_helper'

describe 'SitePrism::VERSION' do
  subject { SitePrism::VERSION }

  it { is_expected.to eq('2.11') }
end
