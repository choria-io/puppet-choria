require "spec_helper"

describe("choria::config") do
  before(:each) do
    Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) {|_| }
  end

  let(:node) { "choria1.rspec.example.net" }
  let(:facts) do
    {
      "aio_agent_version" => "1.7.0",
      "operatingsystem" => "CentOS",
      "osfamily" => "RedHat",
      "operatingsystemmajrelease" => "7",
      "networking" => {
        "domain" => "rspec.example.net",
        "fqdn" => "choria1.rspec.example.net"
      },
      "os" => {
        "family" => "RedHat"
      }
    }
  end

  let(:pre_condition) { 'class {"choria": }' }

  context("default server config") do
    it "should work out of the box" do
      is_expected.to contain_file("/etc/choria/server.conf")
        .with_content(/logfile = .var.log.choria.log/)
        .with_content(/loglevel = warn/)
        .with_content(/identity = choria1.rspec.example.net/)
        .with_content(/plugin.choria.srv_domain = rspec.example.net/)
        .with_content(/collectives = mcollective/)
        .with_content(/classesfile = \/opt\/puppetlabs\/puppet\/cache\/state\/classes.txt/)
    end

    it "should include the agent shim" do
      is_expected.to contain_file("/usr/bin/choria_mcollective_agent_compat.rb")
        .with_mode("0755")
    end
  end
end
