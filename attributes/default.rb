### Users configuration ###
default['mw_server_base']['authorization']['superadmin_group'] = 'sysadmin'
# The attribute addition_superadmin_group is useful when one needs to add additional admins
# that will be limited to an environment, a host or a group of them.
default['mw_server_base']['authorization']['additional_superadmin_group'] = nil
# Sudoers configuration.
default['mw_server_base']['authorization']['sudo']['passwordless'] = true
default['mw_server_base']['authorization']['sudo']['include_sudoers_d'] = true

### Mail relay information ###
default['mw_server_base']['postfix']['vault']['name'] = 'mailers'
default['mw_server_base']['postfix']['vault']['item'] = nil
default['mw_server_base']['postfix']['sasl']['enabled'] = 'no'

# Whether to run apt-get upgrade the first time the recipe is called or not.
default['mw_server_base']['apt']['first_upgrade'] = true

# Timezone to set up the server with.
default['mw_server_base']['timezone'] = 'America/Argentina/Buenos_Aires'
default['mw_server_base']['locale']['lang'] = 'en_US.UTF-8'
default['mw_server_base']['locale']['lc_all'] = 'en_US.UTF-8'
