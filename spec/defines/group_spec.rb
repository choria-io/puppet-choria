require 'spec_helper'

describe 'choria::group' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} " do
      let :facts do
        os_facts
      end

      let(:title) { 'sysadmins' }

      let(:params) do
        {
          members: [
            'choria=alice.mcollective',
            'choria=bob.mcollective',
          ],
        }
      end

      polices_group_files = case os_facts[:os]['family']
                            when 'FreeBSD' then '/usr/local/etc/choria/policies/groups'
                            when 'windows' then 'C:/ProgramData/choria/etc/policies/groups'
                            else '/etc/choria/policies/groups'
                            end

      it { is_expected.to contain_concat(polices_group_files) }
      it { is_expected.to contain_concat__fragment('choria-policies-groups-sysadmins').with(target: polices_group_files, content: "sysadmins choria=alice.mcollective choria=bob.mcollective\n") }
    end
  end
end
