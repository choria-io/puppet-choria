require "spec_helper"

describe("choria::repo") do
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

  context("when managing a redhat family node") do
    let(:facts) do
      {
        "aio_agent_version" => "1.7.0",
        "os" => {
          "family" => "RedHat"
        }
      }
    end

    it { should compile.with_all_deps }

    it "should manage the main repo" do
      is_expected.to contain_yumrepo("choria_release").with_ensure("present")
    end

    context("nightlys") do
      let(:params) do
        { :nightly => true }
      end

      it "should support nightlys repo" do
        is_expected.to contain_yumrepo("choria_release").with_ensure("present")
        is_expected.to contain_yumrepo("choria_nightly").with_ensure("present")
      end
    end
  end

  context("non redhat") do
    let(:facts) do
      {
        "aio_agent_version" => "1.7.0",
        "os" => {
          "distro" => {},
          "family" => "Unsupported"
        }
      }
    end

    it { is_expected.to compile.and_raise_error(/Choria Repositories are not supported on Unsupported/) }
  end
end
