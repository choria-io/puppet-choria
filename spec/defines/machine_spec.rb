require 'spec_helper'

describe 'choria::machine' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} " do
      let :facts do
        os_facts
      end

      let(:title) { 'example' }

      let(:params) do
        {
          initial_state: 'IDLE',
          version: '1.2.3',
          transitions: [],
          watchers: [],
        }
      end

      let(:pre_condition) { 'include choria' }

      machine_store = case os_facts[:os]['family']
                            when 'FreeBSD' then '/usr/local/etc/choria/machine'
                            when 'windows' then 'C:/ProgramData/choria/etc/machine'
                            else '/etc/choria/machine'
                            end

      it { is_expected.to contain_file("#{machine_store}/#{title}").with_ensure('directory') }
      it { is_expected.to contain_file("#{machine_store}/#{title}/machine_data.json").with_ensure('present') }
      it do
        is_expected.to contain_file("#{machine_store}/#{title}/machine.yaml")
          .with_ensure('present')
          .without_content(%r{^splay_start:})
      end

      context 'with splay_start' do
        let(:params) { super().merge(splay_start: 123) }

        it { is_expected.to contain_file("#{machine_store}/#{title}/machine.yaml").with_content(%r{^splay_start: 123$}) }
      end
    end
  end
end

