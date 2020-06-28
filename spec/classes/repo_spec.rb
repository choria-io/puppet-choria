require "spec_helper"

describe("choria::repo") do
  before(:each) do
    Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) {|_| }
  end

  let :pre_condition do
    'class { "choria": }'
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
          "family" => "RedHat",
          "name" => "CentOS",
          "release" => {
            "major" => "7"
          }
        }
      }
    end

    it { should compile.with_all_deps }

    it "should manage the main repo" do
      is_expected.to contain_yumrepo("choria_release").with_ensure("present")
      is_expected.to contain_yumrepo("choria_release").with(baseurl: %r{/\$releasever/})
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

  context("when managing a fedora node") do
    let(:facts) do
      {
        "aio_agent_version" => "1.7.0",
        "os" => {
          "family" => "RedHat",
          "name" => "Fedora",
          "release" => {
            "major" => "30"
          }
        }
      }
    end

    it { should compile.with_all_deps }

    it "should manage the main repo" do
      is_expected.to contain_yumrepo("choria_release").with_ensure("present")
      is_expected.to contain_yumrepo("choria_release").with(baseurl: %r{/7/})
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

  context("when managing a debian node") do
    let(:facts) do
      {
        "osfamily" => "Debian",
        "aio_agent_version" => "1.7.0",
        "os" => {
          "distro" => {
            "codename" => "stretch",
            "description" => "Debian GNU/Linux 9 (stretch)",
            "id" => "Debian",
            "release" => {
              "full" => "9",
              "major" => "9"
            }
          },
          "family" => "Debian",
          "name" => "Debian",
          "release" => {
            "major" => "9"
          }
        }
      }
    end

    it "should manage the main repo" do
      is_expected.to contain_file('/etc/apt/sources.list.d/choria-release.list')
    end

  end

  context("when managing an ubuntu bionic node") do
    let(:facts) do
      {
        "osfamily" => "Debian",
        "aio_agent_version" => "1.7.0",
        "os" => {
          "distro" => {
            "codename" => "bionic",
            "description" => "Ubuntu 18.04.4 LTS",
            "id" => "Ubuntu",
            "release" => {
              "full" => "18.04",
              "major" => "18.04"
            }
          },
          "family" => "Debian",
          "name"   => "Ubuntu",
          "release" => {
            "major" => "18.04",
            "full" => "18.04"
          }
        }
      }
    end

    it "should manage the main repo" do
      is_expected.to contain_file('/etc/apt/sources.list.d/choria-release.list')
      is_expected.to contain_apt__source('choria-release').with(release: 'bionic')
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
