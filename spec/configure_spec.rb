# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  after(:all) do
    SitePrism.configure do |config|
      config.use_implicit_waits = true
    end
  end

  it 'should have implicit waits disabled by default' do
    expect(SitePrism.use_implicit_waits).to be true
  end

  it 'can be configured to not use implicit waits' do
    SitePrism.configure { |config| config.use_implicit_waits = false }

    expect(SitePrism.use_implicit_waits).to be false
  end
end
