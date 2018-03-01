require "spec_helper"

describe("choria") do
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

  it { should compile.with_all_deps }

  context("repo") do
    it "should not manage the repo by default" do
      is_expected.to_not contain_class("choria::repo")
    end

    context do
      let(:params) do
        {
          "manage_package_repo" => true
        }
      end

      it "should support managing the repo by default" do
        is_expected.to contain_class("choria::repo").with_nightly(false)
        is_expected.to contain_class("choria::repo").with_ensure("present")
      end
    end

    context do
      let(:params) do
        {
          "manage_package_repo" => true,
          "nightly_repo" => true,
          "ensure" => "absent"
        }
      end

      it "should manage nightlys and ensure" do
        is_expected.to contain_class("choria::repo").with_nightly(true)
        is_expected.to contain_class("choria::repo").with_ensure("absent")
      end
    end
  end
end
