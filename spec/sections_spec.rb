require 'spec_helper'

describe Prismatic::Page do
  it "should respond to sections" do
    Prismatic::Page.should respond_to :sections
  end
end