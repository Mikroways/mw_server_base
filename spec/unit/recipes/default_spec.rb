require 'spec_helper'
require 'chef-vault'

describe 'mw_server_base::default' do
  cached(:chef_run) do
    stub_command('which sudo').and_return('/usr/bin/sudo')
    ChefSpec::SoloRunner.new do |node|
      node.set['mw_server_base']['postfix']['vault']['item'] = 'test'
      ChefVault::Item.stub(:vault?).with('mailers', 'test').and_return('test')
      ChefVault::Item.stub(:load).with('mailers', 'test').and_return('test')
    end.converge(described_recipe)
  end

  it 'should include mw_server_base::setup & mw_server_base::postfix recipes' do
    expect(chef_run).to include_recipe('mw_server_base::setup')
    expect(chef_run).to include_recipe('mw_server_base::postfix')
  end
end

