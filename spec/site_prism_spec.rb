# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  # This stops the stdout process leaking between tests
  after(:each) { wipe_logger! }

  describe '.logger' do
    context 'at default severity' do
      it 'does not log messages below UNKNOWN' do
        log_messages = capture_stdout do
          SitePrism.logger.debug('DEBUG')
          SitePrism.logger.info('INFO')
          SitePrism.logger.warn('WARN')
          SitePrism.logger.error('ERROR')
          SitePrism.logger.fatal('FATAL')
        end

        expect(log_messages).to be_empty
      end

      it 'logs UNKNOWN level messages' do
        log_messages = capture_stdout do
          SitePrism.log_level = "debug"
          SitePrism.logger.info('INFO')
          SitePrism.logger.unknown('UNKNOWN')
        end

        expect(log_messages).not_to be_empty
      end
    end

    context 'at an altered severity' do
      it 'logs messages at all levels' do
        log_messages = capture_stdout do
          SitePrism.log_level = "debug"

          SitePrism.logger.debug('DEBUG')
          SitePrism.logger.info('INFO')
          SitePrism.logger.warn('WARN')
        end

        expect(lines(log_messages)).to eq(3)
      end
    end
  end

  describe '.log_level' do
    subject { SitePrism.log_level }

    context 'by default' do
      it { is_expected.to eq(:UNKNOWN) }
    end

    context 'after being changed to INFO' do
      before { SitePrism.log_level = :INFO }

      it { is_expected.to eq(:INFO) }
    end
  end

  describe '.log_level=' do
    it 'can alter the log level' do
      expect(SitePrism).to respond_to(:log_level=)
    end
  end

  describe '.configure' do
    it 'can configure the logger in a configure block' do
      expect(SitePrism).to receive(:configure).once

      SitePrism.configure { |_| :foo }
    end

    it 'yields the configured options' do
      expect(SitePrism).to receive(:logger)
      expect(SitePrism).to receive(:log_level)
      expect(SitePrism).to receive(:log_level=)

      SitePrism.configure do |config|
        config.logger
        config.log_level
        config.log_level = :WARN
      end
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    begin
      yield
      return_string = $stdout.string
    ensure
      $stdout = original_stdout
    end
    return_string
  end

  def wipe_logger!
    return unless SitePrism.instance_variable_get(:@logger)

    SitePrism.remove_instance_variable(:@logger)
  end

  def lines(string)
    string.split("\n").length
  end
end
