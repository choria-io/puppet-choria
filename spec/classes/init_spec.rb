require "spec_helper"

describe 'choria' do

  let :node do
    'rspec.puppet.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end
      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('choria') }
        it { is_expected.to contain_class('choria::config') }
        it { is_expected.to contain_class('choria::install') }
        it { is_expected.to contain_class('choria::service') }
        it { is_expected.to contain_class('choria::scout_checks') }
        it { is_expected.to contain_class('choria::scout_metrics') }

        if facts[:kernel] == 'windows'
          it { is_expected.not_to contain_service('choria-server') }
        else
          it { is_expected.to contain_service('choria-server').with_ensure('running').with_enable('true') }
        end

        context 'on Windows', if: facts[:kernel] == 'windows' do
          it { is_expected.to contain_file('C:/Program Files/choria/bin/choria_mcollective_agent_compat.bat') }
          it { is_expected.to contain_file('C:/Program Files/choria/bin/choria_mcollective_agent_compat.rb') }
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/machine').with_ensure('directory') }
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/overrides.json') }
          it { is_expected.to contain_file('C:/ProgramData/choria/etc/server.conf') }
        end
        context 'on linux', if: facts[:kernel] == 'Linux' do
          it { is_expected.to contain_file('/etc/choria/machine') }
          it { is_expected.to contain_file('/etc/choria/machine') }
          it { is_expected.to contain_file('/etc/choria/machine') }
          it { is_expected.to contain_file('/etc/choria/machine') }
          it { is_expected.to contain_file('/etc/choria/overrides.json') }
          it { is_expected.to contain_file('/etc/choria/plugin.d').with_ensure('link') }
          it { is_expected.to contain_file('/etc/choria/policies').with_ensure('link') }
          it { is_expected.to contain_file('/etc/choria/machine').with_ensure('directory') }
        end
        context 'on FreeBSD', if: facts[:os]['name'] == 'FreeBSD' do
          it { is_expected.to contain_file('/usr/local/bin/choria_mcollective_agent_compat.rb') }
          it { is_expected.to contain_file('/usr/local/etc/choria/overrides.json') }
          it { is_expected.to contain_file('/usr/local/etc/choria/plugin.d').with_ensure('link') }
          it { is_expected.to contain_file('/usr/local/etc/choria/policies').with_ensure('link') }
          it { is_expected.to contain_file('/usr/local/etc/choria/server.conf') }
          it { is_expected.to contain_file('/usr/local/etc/choria/machine').with_ensure('directory') }
        end

        if ['FreeBSD', 'AIX', 'Solaris', 'windows', 'SLES'].include? facts[:os]['name']
          it { is_expected.not_to contain_class('choria::repo') }
        else
          it { is_expected.to contain_class('choria::repo') }
        end
      end

      context 'repo related tests' do
        context 'should not manage the repo if its disabled' do
          let :params do
            { manage_package_repo: false }
          end

          it { is_expected.to_not contain_class('choria::repo') }
        end

        context 'with manage_package_repo set to true' do
          let :params do
            { manage_package_repo: true }
          end

          if facts[:kernel] == 'Linux' and facts[:os]['family'] != 'Suse'
            it { is_expected.to contain_class("choria::repo").with_nightly(false) }
            it { is_expected.to contain_class("choria::repo").with_ensure("present") }
          else
            it { is_expected.to compile.and_raise_error(/Choria Repositories are not supported on/) }
          end

          context 'on Debian OS family', if: facts[:os]['family'] == 'Debian' do
            it { is_expected.to contain_apt__source('choria-release') }
            it { is_expected.to contain_apt__source('choria-nightly') }
          end

          context 'on RedHat OS family', if: facts[:os]['family'] == 'RedHat' do
            it { is_expected.to contain_yumrepo('choria_nightly') }
            it { is_expected.to contain_yumrepo('choria_release') }
          end
        end

        context 'with managed repos', if: (facts[:kernel] == 'Linux' and facts[:os]['family'] != 'Suse') do
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

        context 'with custom repo on CentOS', if: facts[:os]['name'] == 'CentOS' do
          let(:params) do
            {
              "manage_package_repo" => true,
              "repo_baseurl" => 'http://internal-mirror.com/choria'
            }
          end

          it "should support managing the repo by default" do
            is_expected.to contain_class("choria::repo").with_nightly(false)
            is_expected.to contain_class("choria::repo").with_ensure("present")
            is_expected.to contain_yumrepo("choria_release").with_ensure("present").with_baseurl('http://internal-mirror.com/choria/release/el/$releasever/$basearch')
          end
        end

        context "when managing an ubuntu bionic node", if: facts[:os]['release']['major'] == '18.04' do
          let(:params) do
            {
              "manage_package_repo" => true,
              "repo_baseurl" => 'http://internal-mirror.com/choria'
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

        context "when managing an ubuntu xenial node", if: facts[:os]['release']['major'] == '16.04' do
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
      context "default server config", if: facts[:kernel] == 'Linux' do
        it "should work out of the box" do
          is_expected.to contain_file("/etc/choria/server.conf")
            .with_content(/logfile = .var.log.choria.log/)
            .with_content(/loglevel = warn/)
            .with_content(/identity = rspec.puppet.com/)
            .with_content(/plugin.choria.srv_domain = puppet.com/)
            .with_content(/collectives = mcollective/)
            .with_content(/classesfile = \/opt\/puppetlabs\/puppet\/cache\/state\/classes.txt/)
            .with_content(/plugin.choria.status_file_path = .var.log.choria-status.json/)
        end

        it "should include the agent shim" do
          is_expected.to contain_file("/usr/bin/choria_mcollective_agent_compat.rb")
            .with_mode("0755")
        end

        context("with status file configured") do
          let(:pre_condition) { 'class {"choria": statusfile => "/tmp/status", status_write_interval => 10}' }

          it "should support writing the status file" do
            is_expected.to contain_file("/etc/choria/server.conf")
              .with_content(/plugin.choria.status_file_path = .tmp.status/)
              .with_content(/plugin.choria.status_update_interval = 10/)
          end
        end
      end

      context "custom server config", if: facts[:kernel] == 'Linux' do
        let :params do
          {
            server_config: {
              "plugin.choria.security.certname_whitelist": ["user1", "user2"]
            }
          }
        end

        it "should support arrays in choria::server_config" do
          is_expected.to contain_file("/etc/choria/server.conf")
            .with_content(/plugin.choria.security.certname_whitelist = user1, user2/)
        end
      end

      context "custom logging", if: facts[:kernel] == 'Linux' do
        let :params do
         {
           server_logfile: "/var/log/choria-server.log",
           server_log_level: "debug"
         }
        end

        it "should use the supplied logging" do
          is_expected.to contain_file("/etc/choria/server.conf").with_content(/logfile = \/var\/log\/choria-server\.log/)
            .with_content(/loglevel = debug/)
        end
      end
      context "with package set to a specific version" do
        let :params do
          { version: '1.2.3' }
        end

        if facts[:kernel] == 'SunOS' and facts[:os]['release']['major'].to_i == 10
          it { is_expected.not_to compile }
        else
          it { is_expected.to compile.with_all_deps }
        end

        if facts[:kernel] == 'windows'
          it { is_expected.not_to contain_package('choria') }
        else
          it "should use the correct ensure value" do
            is_expected.to contain_package("choria").with_ensure("1.2.3")
          end
        end
      end

      context 'with package ensure set to absent' do
        let :params do
          { ensure: 'absent' }
        end

          it { should compile.with_all_deps }

        if facts[:kernel] == 'windows'
          it { is_expected.not_to contain_package('choria') }
        else
          it 'should use the correct ensure value' do
            is_expected.to contain_package('choria').with_ensure('absent')
          end
        end
      end
    end
  end
end
