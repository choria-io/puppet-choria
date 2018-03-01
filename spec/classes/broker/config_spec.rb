require "spec_helper"

describe("choria::broker::config") do
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

  let(:pre_condition) { 'class {"choria": }' }

  context("without the network broker") do
    let(:pre_condition) { 'class {"choria::broker": network_broker => false}' }

    it { should compile.with_all_deps }

    it "should enable the broker" do
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/JSON information about this broker/)
      is_expected.to contain_file("/etc/choria/broker.cfg").without_content(/Embedded NATS general statistics/)
      is_expected.to contain_file("/etc/choria/broker.cfg").without_content(/plugin.choria.broker_network = true/)
      is_expected.to contain_file("/etc/choria/broker.cfg").without_content(/plugin.choria.network.peers/)
    end
  end

  context("standalone network broker") do
    let(:pre_condition) { 'class {"choria::broker": network_broker => true}' }

    it { should compile.with_all_deps }

    it "should enable the broker" do
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/Embedded NATS general statistics/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.broker_network = true/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.listen_address = 0.0.0.0/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.client_port = 4222/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.peer_port = 5222/)
      is_expected.to contain_file("/etc/choria/broker.cfg").without_content(/plugin.choria.network.peers/)
    end
  end

  context("clustered network broker") do
    let(:pre_condition) { 'class {"choria::broker": network_broker => true, network_peers => ["nats://n1:5222", "nats://n2:5222"]}' }

    it { should compile.with_all_deps }

    it "should enable the broker" do
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/Embedded NATS general statistics/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.broker_network = true/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.listen_address = 0.0.0.0/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.client_port = 4222/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.peer_port = 5222/)
      is_expected.to contain_file("/etc/choria/broker.cfg").with_content(/plugin.choria.network.peers = nats:\/\/n1:5222, nats:\/\/n2:5222/)
    end
  end
end
