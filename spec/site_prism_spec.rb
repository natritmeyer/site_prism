# frozen_string_literal: true

describe SitePrism do
  # Stop the $stdout process leaking cross-tests
  before(:each) { wipe_logger! }

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
          SitePrism.logger.info('INFO')
          SitePrism.logger.unknown('UNKNOWN')
        end

        expect(lines(log_messages)).to eq(1)
      end
    end

    context 'at an altered severity' do
      it 'logs messages at all levels above the new severity' do
        log_messages = capture_stdout do
          SitePrism.log_level = :DEBUG

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

  describe '.log_output=' do
    context 'to a file' do
      let(:filename) { 'sample.log' }
      let(:file_content) { File.read(filename) }

      before { SitePrism.log_output = filename }
      after { File.delete(filename) if File.exist?(filename) }

      it 'sends the log messages to the file-path provided' do
        SitePrism.logger.unknown('This is sent to the file')

        expect(file_content).to end_with("This is sent to the file\n")
      end
    end

    context 'to $stderr' do
      it 'sends the log messages to $stderr' do
        expect do
          SitePrism.log_output = $stderr
          SitePrism.logger.unknown('This is sent to $stderr')
        end.to output(/This is sent to \$stderr/).to_stderr
      end
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end

  def wipe_logger!
    return unless SitePrism.instance_variable_get(:@logger)

    SitePrism.remove_instance_variable(:@logger)
  end

  def lines(string)
    string.split("\n").length
  end
end
