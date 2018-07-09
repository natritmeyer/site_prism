# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  after(:all) do
    SitePrism.configure do |config|
      config.use_implicit_waits = false
      config.raise_on_wait_fors = false
    end
  end

  it 'should have implicit waits disabled by default' do
    expect(SitePrism.use_implicit_waits).to be false
  end

  it 'can be configured to use implicit waits' do
    SitePrism.configure { |config| config.use_implicit_waits = true }

    expect(SitePrism.use_implicit_waits).to be true
  end

  it 'should have `raise_on_wait_fors` disabled by default' do
    expect(SitePrism.raise_on_wait_fors).to be false
  end

  it 'can be configured to enable `raise_on_wait_fors`' do
    SitePrism.configure { |config| config.raise_on_wait_fors = true }

    expect(SitePrism.raise_on_wait_fors).to be true
  end
end
