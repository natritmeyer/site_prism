# frozen_string_literal: true

module SitePrism
  # To enable full logging
  #   SitePrism.log_level = "debug"
  #
  # To disable all logging (Done by default)
  #   SitePrism.log_level = "unknown"
  #
  # To Manually log a message
  #   SitePrism.logger.info('Information')
  #   SitePrism.logger.debug('Input debug message')
  class Logger
    def create(output = $stdout)
      logger = ::Logger.new(output)
      logger.progname = 'SitePrism'
      logger.level = :UNKNOWN
      logger.formatter = proc do |severity, time, progname, msg|
        "#{time.strftime('%F %T')} - #{severity} - #{progname} - #{msg}\n"
      end

      logger
    end
  end
end
