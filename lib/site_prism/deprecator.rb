# frozen_string_literal: true

module SitePrism
  class Deprecator
    class << self
      def deprecate(old, new = nil)
        if new
          warn("#{old} is being deprecated and should no longer be used. Use #{new} instead.")
        else
          warn("#{old} is being deprecated and should no longer be used.")
        end

        warn("#{old} will be removed in SitePrism v4. You have been warned!")
      end

      def soft_deprecate(old, reason, new = nil)
        debug("The #{old} method is changing, as is SitePrism, and is now configurable.")
        debug("REASON: #{reason}.")
        debug('Moving forwards into SitePrism v4, the default behaviour will change.')
        debug("We advise you change to using #{new}") if new
      end

      private

      def warn(msg)
        SitePrism.logger.warn(msg)
      end

      def debug(msg)
        SitePrism.logger.debug(msg)
      end
    end
  end
end
