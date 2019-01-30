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

    context do
      let(:params) do
        {
          "manage_package_repo" => true,
          "repo_baseurl" => 'http://internal-mirror.com/choria'
        }
      end

      it "should support managing the repo by default" do
        is_expected.to contain_class("choria::repo").with_nightly(false)
        is_expected.to contain_class("choria::repo").with_ensure("present")
        is_expected.to contain_yumrepo("choria_release").with_ensure("present")
                         .with_baseurl('http://internal-mirror.com/choria/release/el/$releasever/$basearch')
      end
    end

    context do
      let(:params) do
        {
          "manage_package_repo" => true,
          "repo_baseurl" => 'http://internal-mirror.com/choria'
        }
      end
      let(:facts) do
        {
          "osfamily" => "Debian",
          "aio_agent_version" => "1.7.0",
          "os" => {
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
        is_expected.to contain_class("choria::repo").with_nightly(false)
        is_expected.to contain_class("choria::repo").with_ensure("present")
        is_expected.to contain_file('/etc/apt/sources.list.d/choria-release.list')
        is_expected.to contain_apt__source('choria-release').with(release: 'bionic')
                         .with(location: 'http://internal-mirror.com/choria/release/ubuntu/')
      end
    end

    context("when managing an ubuntu xenial node") do
      let(:facts) do
        {
          "osfamily" => "Debian",
          "aio_agent_version" => "1.7.0",
          "os" => {
            "family" => "Debian",
            "name"   => "Ubuntu",
            "release" => {
              "major" => "16.04",
              "full" => "16.04"
            }
          }
        }
      end
      let :params do
        {
          "manage_package_repo" => true,
          "repo_baseurl" => 'http://internal-mirror.com/choria'
        }
      end

      it "should manage the main repo" do
        is_expected.to contain_file('/etc/apt/sources.list.d/choria-release.list')
        is_expected.to contain_apt__source('choria-release')
                         .with(release: 'xenial')
                         .with(location: 'http://internal-mirror.com/choria/release/ubuntu/')
      end
    end
  end
end
