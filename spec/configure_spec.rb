# frozen_string_literal: true

require 'spec_helper'

describe 'SitePrism configuration' do
  subject { SitePrism.configure { |config| config.unused_config = true } }

  let(:warning_message_one) { 'SitePrism configuration is now removed.' }
  let(:warning_message_two) { 'All options fed directly from Capybara.' }
  let(:warning_message) { "#{warning_message_one}\n#{warning_message_two}\n" }

  it 'should warn users that no more configuration is possible' do
    expect { subject }.to output(warning_message).to_stderr
  end
end
