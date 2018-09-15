require 'logger'

module SitePrism

  # @example Enable full logging
  #   SitePrism.enable_logging = true
  #
  # @example Disable all logging (Done by default)
  #   SitePrism.enable_logging = false
  #
  # @example Manually log a message
  #   SitePrism.logger.info('Information')
  #   SitePrism.logger.debug('Input debug message')
  class Logger
    def create(output)
      logger = ::Logger.new(output)
      logger.progname = 'SitePrism'
      logger.level = level
      logger.formatter = proc do |severity, time, progname, msg|
        "#{time.strftime('%F %T')} - #{severity} - #{progname} - #{msg}\n"
      end

      logger
    end

    def level
      if SitePrism.enable_logging
        0 # This is equivalent to debug standard logging
      else
        5 # This is equivalent to unknown (or no), logging
      end
    end
  end
end
