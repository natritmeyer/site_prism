# frozen_string_literal: true

require 'spec_helper'

describe 'SitePrism configuration' do
  after(:each) do
    SitePrism.configure do |config|
      config.enable_logging = false
    end
  end

  it 'should have logging disabled by default' do
    expect(SitePrism.enable_logging).to be false
  end

  it 'can be configured to log information' do
    SitePrism.configure { |config| config.enable_logging = true }

    expect(SitePrism.enable_logging).to be true
  end
end

# TODO: Move logger class specs to here, rename to site_prism_spec.rb