# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Logger do
  describe '#create' do
    subject { SitePrism::Logger.new.create }

    it { is_expected.to be_a Logger }

    it 'has default attributes' do
      expect(subject.progname).to eq('SitePrism')

      expect(subject.level).to eq(5)
    end
  end
end
