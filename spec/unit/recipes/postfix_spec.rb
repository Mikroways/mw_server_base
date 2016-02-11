require 'spec_helper'
require 'chef-vault'

describe 'mw_server_base::postfix' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['mw_server_base']['postfix']['vault']['item'] = 'test'
      expect(ChefVault::Item).to receive(:vault?).with('mailers', 'test').and_return('test')
      expect(ChefVault::Item).to receive(:load).with('mailers', 'test').and_return('test')
    end.converge(described_recipe)
  end

  it 'should raise an exception when vault item is not specified' do
    chef_run = ChefSpec::SoloRunner.new
    chef_run.node.set['mw_server_base']['postfix']['vault']['item'] = nil
    expect { chef_run.converge(described_recipe) }.to raise_error(RuntimeError, 'Vault item must be specified to be able to setup mail server relay.')
  end

  it 'should include recipe chef-vault::default' do
    expect(chef_run).to include_recipe('chef-vault::default')
  end

  it 'should include recipe postfix::default' do
    expect(chef_run).to include_recipe('postfix::default')
  end

  it 'should not include recipe postfix::aliases by default' do
    expect(chef_run).to_not include_recipe('postfix::aliases')
  end

  describe 'aliases hash is defined in vault' do
    it 'should include recipe postfix::aliases when there is aliases in data bag' do
      chef_run = ChefSpec::SoloRunner.new do |node|
        node.set['mw_server_base']['postfix']['vault']['item'] = 'test'
        expect(ChefVault::Item).to receive(:vault?).with('mailers', 'test').and_return('test')
        expect(ChefVault::Item).to receive(:load).with('mailers', 'test').and_return('aliases' => true)
      end.converge(described_recipe)
      expect(chef_run).to include_recipe('postfix::aliases')
    end
  end
end
