case node['platform_family']
when 'debian'
  include_recipe 'apt'

  # Unattended upgrades configuration.
  node.set['apt']['unattended_upgrades']['update_package_lists'] = true
  node.set['apt']['unattended_upgrades']['allowed_origins'] = [
    '${distro_id} ${distro_codename}-security'
  ]
  # We should have an alias for root account.
  node.set['apt']['unattended_upgrades']['mail'] = 'root@localhost'
  node.set['apt']['unattended_upgrades']['remove_unused_dependencies'] = true

  include_recipe 'apt::unattended-upgrades'

  execute 'apt-upgrade' do
    command <<-CMD
        unset UCF_FORCE_CONFFOLD
        export UCF_FORCE_CONFFNEW=YES
        ucf --purge /boot/grub/menu.lst
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get -o Dpkg::Options::="--force-confdef" --force-yes -fuy upgrade
    CMD
    action :nothing
  end

  # If file /root/.apt-upgrade-once does not exist and
  # node['mw_server_base']['apt']['first_upgrade'] is set to true, execute apt-get upgrade.
  # This should only be executed once, the first time this recipe is called.
  file '/root/.apt-upgrade-once' do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    notifies :run, 'execute[apt-upgrade]', :immediately
    only_if { node['mw_server_base']['apt']['first_upgrade'] }
  end
when 'rhel'
  include_recipe 'yum-epel'
end

include_recipe 'mw_server_base::users'
include_recipe 'mw_server_base::basic_packages'

timezone node['mw_server_base']['timezone']

node.set['locale']['lang'] = node['mw_server_base']['locale']['lang']
node.set['locale']['lc_all'] = node['mw_server_base']['locale']['lc_all']

include_recipe 'locale'
