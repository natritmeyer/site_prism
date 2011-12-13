require 'spec_helper'

describe Prismatic::Page do
  it "should respond to load" do
    Prismatic::Page.new.should respond_to :load
  end
end