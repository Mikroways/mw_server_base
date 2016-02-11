require 'spec_helper'

describe 'mw_server_base::setup' do
  describe 'when platform family is debian' do
    cached(:chef_run) do
      stub_command('which sudo').and_return('/usr/bin/sudo')
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe)
    end

    it 'should include apt and not yum' do
      expect(chef_run).to include_recipe('apt')
      expect(chef_run).to include_recipe('apt::unattended-upgrades')
      expect(chef_run).to_not include_recipe('yum-epel')
    end

    it 'should create a file for apt-upgrade' do
      expect(chef_run).to create_file('/root/.apt-upgrade-once').with(
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'should notify execute apt-get upgrade' do
      expect(chef_run.file('/root/.apt-upgrade-once')).to notify('execute[apt-upgrade]').to(:run).immediately
    end

    it 'should define a resource apt-upgrade which does nothing by default' do
      expect(chef_run.execute('apt-upgrade')).to do_nothing
    end
  end

  describe 'when platform family is rhel' do
    cached(:chef_run) do
      stub_command('which sudo').and_return('/usr/bin/sudo')
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.1').converge(described_recipe)
    end

    it 'should include yum and not apt' do
      expect(chef_run).to_not include_recipe('apt')
      expect(chef_run).to_not include_recipe('apt::unattended-upgrades')
      expect(chef_run).to include_recipe('yum-epel')
    end

    it 'should notify execute apt-get upgrade' do
      expect(chef_run).to_not create_file('/root/.apt-upgrade-once')
    end
  end

  describe 'with any platform' do
    platforms_to_test = [
      { 'ubuntu' => '14.04' },
      { 'redhat' => '7.1' }
    ]

    platforms_to_test.each do |so|
      so.each do |platform, version|
        cached(:chef_run) do
          stub_command('which sudo').and_return('/usr/bin/sudo')
          ChefSpec::ServerRunner.new(platform: platform, version: version).converge(described_recipe)
        end

        it 'should include mw_server_base::users & mw_server_base::basic_packages recipes' do
          expect(chef_run).to include_recipe('mw_server_base::users')
          expect(chef_run).to include_recipe('mw_server_base::basic_packages')
        end

        it 'should set the timezone to America/Argentina/Buenos_Aires by default' do
          expect(chef_run.node['mw_server_base']['timezone']).to eq('America/Argentina/Buenos_Aires')
        end
      end
    end
  end
end
