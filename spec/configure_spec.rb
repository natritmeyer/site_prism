# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  it 'should have implicit waits disabled by default' do
    expect(SitePrism.use_implicit_waits).to be false
  end

  it 'can be configured to use implicit waits' do
    SitePrism.configure do |config|
      config.use_implicit_waits = true
    end
    expect(SitePrism.use_implicit_waits).to be true
  end
end
