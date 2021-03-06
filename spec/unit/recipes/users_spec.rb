require 'spec_helper'

describe 'mw_server_base::users' do
  cached(:chef_run) do
    stub_command('which sudo').and_return('/usr/bin/sudo')
    ChefSpec::ServerRunner.new(step_into: ['users_manage']) do |node, server|
      server.create_data_bag('users',
        leandro: {
          id: 'leandro',
          groups: ['sysadmin']
        },
        christian: {
          id: 'christian',
          groups: ['additional_admin']
        },
        dummy: {
          id: 'dummy',
          groups: ['not_admin']
        }
                            )
      node.set['mw_server_base']['authorization']['additional_superadmin_group'] = 'additional_admin'
    end.converge(described_recipe)
  end

  it 'should include recipe users::default & sudo::default' do
    expect(chef_run).to include_recipe('users::default')
    expect(chef_run).to include_recipe('sudo::default')
  end

  it 'should create users_manage[sysadmin] & users_manage[additional_admin] & not create users_manage[not_admin]' do
    expect(chef_run).to create_users_manage('sysadmin')
    expect(chef_run).to create_users_manage('additional_admin')
    expect(chef_run).to_not create_users_manage('not_admin')
  end

  it 'should create groups sysadmin & additional_admin & not create group not_admin' do
    expect(chef_run).to create_group('sysadmin')
    expect(chef_run).to create_group('additional_admin')
    expect(chef_run).to_not create_group('not_admin')
  end

  it 'should create users leandro & christian & not create user dummy' do
    expect(chef_run).to create_user('leandro')
    expect(chef_run).to create_user('christian')
    expect(chef_run).to_not create_user('dummy')
  end
end
