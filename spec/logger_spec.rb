# frozen_string_literal: true

require 'spec_helper'

describe SitePrism::Logger do
  # This stops the stdout process leaking between tests
  after(:each) { wipe_logger! }

  describe '#create' do
    subject { SitePrism::Logger.new.create }

    it { is_expected.to be_a Logger }

    it 'has default attributes' do
      expect(subject.progname).to eq('SitePrism')

      expect(subject.level).to eq(5)
    end
  end

  describe '#level' do
    subject { SitePrism::Logger.new.level }

    after(:each) do
      SitePrism.configure { |config| config.enable_logging = false }
    end

    context 'with logging enabled' do
      before do
        SitePrism.configure { |config| config.enable_logging = true }
      end

      it { is_expected.to eq(0) }
    end

    context 'with logging disabled' do
      it { is_expected.to eq(5) }
    end
  end

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

      expect(log_messages.lines).to eq(3)
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  def wipe_logger!
    return unless SitePrism.instance_variable_get(:@logger)

    SitePrism.remove_instance_variable(:@logger)
  end
end
