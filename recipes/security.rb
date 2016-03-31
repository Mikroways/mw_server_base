# Restrict users who can execute su command just to those belonging
# to super_admin group.
file '/bin/su' do
  owner 'root'
  group node['mw_server_base']['authorization']['superadmin_group']
  mode '4750'
end

# Set some OpenSSH customizations.
node.default['openssh']['server']['use_privilege_separation'] = 'yes'
node.default['openssh']['server']['permit_root_login'] = 'without-password'
node.default['openssh']['server']['password_authentication'] = 'no'
node.default['openssh']['server']['max_auth_tries'] = '4'
node.default['openssh']['server']['pubkey_authentication'] = 'yes'
node.default['openssh']['server']['x11_forwarding'] = 'no'
node.default['openssh']['server']['print_motd'] = 'no'
node.default['openssh']['server']['print_lastlog'] = 'yes'
node.default['openssh']['server']['t_c_p_keep_alive'] = 'yes'
node.default['openssh']['server']['challenge_response_authentication'] = 'no'
node.default['openssh']['server']['use_p_a_m'] = 'yes'
node.default['openssh']['server']['use_dns'] = 'no'
node.default['openssh']['server']['subsystem'] = 'sftp /usr/lib/openssh/sftp-server'

# Fail2Ban specific.
node.default['fail2ban']['bantime'] = 600
node.default['fail2ban']['maxretry'] = 3
node.default['fail2ban']['services'] = {
  'ssh' => {
    'enabled' => true,
    'port' => 'ssh',
    'filter' => 'sshd',
    'logpath' => node['fail2ban']['auth_log'],
    'maxretry' => '4'
  }
}

include_recipe 'openssh'
include_recipe 'fail2ban'
