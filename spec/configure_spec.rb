# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  after(:all) do
    SitePrism.configure do |config|
      config.use_implicit_waits = false
      config.default_load_validations = true
    end
  end

  it 'should have implicit waits disabled by default' do
    expect(SitePrism.use_implicit_waits).to be false
  end

  it 'can be configured to use implicit waits' do
    SitePrism.configure { |config| config.use_implicit_waits = true }

    expect(SitePrism.use_implicit_waits).to be true
  end

  it 'should have `default_load_validations` enabled by default' do
    expect(SitePrism.default_load_validations).to be true
  end

  it 'can be configured to disable `default_load_validations`' do
    SitePrism.configure { |config| config.default_load_validations = false }

    expect(SitePrism.default_load_validations).to be false
  end
end
