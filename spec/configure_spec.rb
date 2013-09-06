require 'spec_helper'

describe SitePrism do
  it "should have implicit waits disabled by default" do
    SitePrism.use_implicit_waits.should be_false
  end

  it "can be configured to use implicit waits" do
    SitePrism.configure do |config|
      config.use_implicit_waits = true
    end
    SitePrism.use_implicit_waits.should be_true
  end
end
