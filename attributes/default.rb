# Basic packages to install.
default['mw_server_base']['basic_packages'] = {
  debian: %w(atsar vim locate apt-utils bsdutils htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep),
  rhel: %w(vim mlocate htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep)
}

# Users configuration.
default['mw_server_base']['authorization']['superadmin_group'] = 'sysadmin'
# The attribute addition_superadmin_group is useful when one needs to add additional admins
# that will be limited to an environment, a host or a group of them.
default['mw_server_base']['authorization']['additional_superadmin_group'] = nil

# Sudoers configuration.
default['mw_server_base']['authorization']['sudo']['passwordless'] = true
default['mw_server_base']['authorization']['sudo']['include_sudoers_d'] = true
