module SitePrism
  class << self
    attr_accessor :use_implicit_waits

    def configure
      yield self
    end
  end

  private

  @@use_implicit_waits = false
end
