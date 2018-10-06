# frozen_string_literal: true

require 'spec_helper'

describe SitePrism do
  describe '.enable_logging' do
    it 'is disabled by default' do
      expect(SitePrism.enable_logging).to be false
    end

    it 'can be configured to log information' do
      SitePrism.configure { |config| config.enable_logging = true }

      expect(SitePrism.enable_logging).to be true
    end
  end

  describe '.logger' do
    # This stops the stdout process leaking between tests
    after(:each) { wipe_logger! }

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
        SitePrism.logger.unknown('UNKNOWN')
      end

      expect(log_messages).not_to be_empty
    end

    context 'with logging enabled' do
      before do
        SitePrism.configure { |config| config.enable_logging = true }
      end

      it 'logs messages at all levels' do
        log_messages = capture_stdout do
          SitePrism.logger.debug('DEBUG')
          SitePrism.logger.info('INFO')
          SitePrism.logger.warn('WARN')
        end

        expect(lines(log_messages)).to eq(3)
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
