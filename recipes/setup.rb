#
# mw_server_base::setup
#
# This recipe executes every other recipe in this cookbook
# and additional recipes from other cookbooks.
#
# Before using this, make sure you've read the README and understood
# what this recipe does.

if node['platform_family'] == 'debian'
  # First step is to setup our mirrors and execute apt-get update.
  include_recipe 'ubuntu'
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

end

timezone node['mw_server_base']['timezone']

include_recipe 'ntp'
include_recipe 'rsyslog'

include_recipe 'mw_server_base::basic_packages'
include_recipe 'mw_server_base::users'
include_recipe 'mw_server_base::postfix'

node.set['locale']['lang'] = 'es_AR.utf8'
node.set['locale']['lc_all'] = 'es_AR.utf8'

include_recipe 'locale'
