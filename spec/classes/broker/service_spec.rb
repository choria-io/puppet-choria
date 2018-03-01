require "spec_helper"

describe("choria::broker::service") do
  before(:each) do
    Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) {|_| }
  end

  let(:facts) do
    {
      "aio_agent_version" => "1.7.0",
      "operatingsystem" => "CentOS",
      "osfamily" => "RedHat",
      "operatingsystemmajrelease" => "7",
      "os" => {
        "family" => "RedHat"
      }
    }
  end

  context("when present") do
    let(:pre_condition) { 'class {"choria": }' }

    it { should compile.with_all_deps }

    it "should use the correct ensure value" do
      is_expected.to contain_service("choria-broker").with_ensure("running")
      is_expected.to contain_service("choria-broker").with_enable(true)
    end
  end

  context("when absent") do
    let(:pre_condition) { 'class {"choria": ensure => "absent"}' }

    it { should compile.with_all_deps }

    it "should use the correct ensure value" do
      is_expected.to contain_service("choria-broker").with_ensure("stopped")
      is_expected.to contain_service("choria-broker").with_enable(false)
    end
  end
end
