require "spec_helper"

describe 'choria::broker' do

  let :node do
    "rspec.puppet.com"
  end

  let :pre_condition  do
    '
    class{choria:
      manage_mcollective => false,
    }
    '
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end
      it { is_expected.to compile.with_all_deps }
      context 'with all defaults' do
        case facts[:os]['family']
        when 'windows'
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/broker.conf') }
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/choria/broker.conf') }
        else
          it { is_expected.to contain_file('/etc/choria/broker.conf').without_content(%r{plugin.choria.network.client_anon_tls}) }
          it { is_expected.to contain_file('/etc/choria/broker.conf').without_content(%r{plugin.choria.security.request_signing_certificate}) }
          it { is_expected.to contain_file('/etc/choria/broker.conf').without_content(%r{plugin.choria.network.deny_server_connections}) }
        end
      end

      context 'with booleans set false' do
        let :params do
          {client_anon_tls: false, deny_server_connections: false}
        end
        case facts[:os]['family']
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/choria/broker.conf') }
        when 'windows'
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/broker.conf') }
        else
          it { is_expected.to contain_file('/etc/choria/broker.conf').without_content(%r{plugin.choria.network.client_anon_tls}) }
          it { is_expected.to contain_file('/etc/choria/broker.conf').without_content(%r{plugin.choria.network.deny_server_connections}) }
        end
      end

      context 'with booleans set true' do
        let :params do
          {client_anon_tls: true, deny_server_connections: true}
        end
        case facts[:os]['family']
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/choria/broker.conf') }
        when 'windows'
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/broker.conf') }
        else
          it { is_expected.to contain_file('/etc/choria/broker.conf').with_content(%r{^plugin.choria.network.client_anon_tls = true$}) }
          it { is_expected.to contain_file('/etc/choria/broker.conf').with_content(%r{^plugin.choria.network.deny_server_connections = true$}) }
        end
      end

      context 'with strings set' do
        let :params do
          {request_signing_certificate: '/tmp/foo.pem'}
        end
        case facts[:os]['family']
        when 'FreeBSD'
          it { is_expected.to contain_file('/usr/local/etc/choria/broker.conf') }
        when 'windows'
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/broker.conf') }
        else
          it { is_expected.to contain_file('/etc/choria/broker.conf').with_content(%r{^plugin.choria.security.request_signing_certificate = /tmp/foo.pem$}) }
        end
      end
    end
  end
end
