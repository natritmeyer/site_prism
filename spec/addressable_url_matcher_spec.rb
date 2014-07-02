require 'spec_helper'

describe SitePrism::AddressableUrlMatcher do

  describe "#matches?" do
    let(:url) { "https://joe:bleep@bazzle.com:8443/foos/22/bars/12?junk=janky#middle" }

    it "matches on templated scheme" do
      expect_matches("{scheme}://bazzle.com").to eq true
    end

    it "matches on static scheme" do
      expect_matches("https://bazzle.com").to eq true
    end

    it "fails on bad scheme" do
      expect_matches("ftp://bazzle.com").to eq false
    end

    it "matches on templated user" do
      expect_matches("//{user}@bazzle.com").to eq true
    end

    it "matches on static user" do
      expect_matches("//joe@bazzle.com").to eq true
    end

    it "fails on bad user" do
      expect_matches("//bob@bazzle.com").to eq false
    end

    it "matches on templated password" do
      expect_matches("//joe:{password}@bazzle.com").to eq true
    end

    it "matches on static password" do
      expect_matches("//joe:bleep@bazzle.com").to eq true
    end

    it "fails on bad password" do
      expect_matches("//joe:bloop@bazzle.com").to eq false
    end

    it "matches on templated host" do
      expect_matches("//{host}").to eq true
    end

    it "matches on static host" do
      expect_matches("//bazzle.com").to eq true
    end

    it "fails on bad host" do
      expect_matches("//bungle.com").to eq false
    end

    it "raises on templated port" do
      expect { matches? "//bazzle.com:{port}" }.to raise_error SitePrism::InvalidUrlMatcher
    end

    it "matches on static port" do
      expect_matches("//bazzle.com:8443").to eq true
    end

    it "fails on bad port" do
      expect_matches("//bungle.com:7654").to eq false
    end
    it "matches on templated path" do
      expect_matches("/foos/{foo_id}/bars{/bar_id}").to eq true
    end

    it "matches on static path" do
      expect_matches("/foos/22/bars/12").to eq true
    end

    it "fails on bad path" do
      expect_matches("/foos/22/bars/123").to eq false
    end

    it "matches on templated query" do
      expect_matches("/foos/22/bars/12{?query*}").to eq true
    end

    it "matches on static path" do
      expect_matches("/foos/22/bars/12").to eq true
    end

    it "fails on bad path" do
      expect_matches("/foos/22/bars/123").to eq false
    end

    it "matches on templated fragment" do
      expect_matches("{#fragment}").to eq true
    end

    it "matches on static fragment" do
      expect_matches("#middle").to eq true
    end

    it "fails on bad fragment" do
      expect_matches("#muddle").to eq false
    end

    it "matches everything at once" do
      expect_matches("{scheme}://{user}:{password}@{host}:8443/foos{/foo_id}/bars{/id}{?params*}#middle").to eq true
    end

    def expect_matches(pattern)
      expect(matches?(pattern))
    end

    def matches?(pattern)
      SitePrism::AddressableUrlMatcher.new(pattern).matches?(url)
    end
  end
end
