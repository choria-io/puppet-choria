require "spec_helper"

describe("choria::install") do
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

  context("when present") do
    let(:pre_condition) { 'class {"choria": version => "1.2.3"}' }

    it { should compile.with_all_deps }

    it "should use the correct ensure value" do
      is_expected.to contain_package("choria").with_ensure("1.2.3")
    end
  end

  context("when absent") do
    let(:pre_condition) { 'class {"choria": ensure => "absent", version => "1.2.3"}' }

    it { should compile.with_all_deps }

    it "should use the correct ensure value" do
      is_expected.to contain_package("choria").with_ensure("absent")
    end
  end
end
