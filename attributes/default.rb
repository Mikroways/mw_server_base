default['mw_server_base']['basic_packages'] = {
  debian: %w(atsar vim locate apt-utils bsdutils htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep),
  rhel: %w(vim mlocate htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep)
}
