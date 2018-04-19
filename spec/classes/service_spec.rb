require "spec_helper"

describe("choria::service") do
  before(:each) do
    Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) {|_| }
  end

  let(:facts) do
    {
      "aio_agent_version" => "1.7.0",
      "os" => {
        "family" => "RedHat"
      }
    }
  end

  context("when enabled") do
    let(:pre_condition) { 'class {"choria": server => true}' }

    it { should compile.with_all_deps }

    it "should enable the service" do
      is_expected.to contain_service("choria-server")
        .with_ensure("running")
        .with_enable(true)
    end
  end

  context("by default") do
    let(:pre_condition) { 'class {"choria": }' }

    it { should compile.with_all_deps }

    it "should disable the service" do
      is_expected.to contain_service("choria-server")
        .with_ensure("stopped")
        .with_enable(false)
    end
  end
end
