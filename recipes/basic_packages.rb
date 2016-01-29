# Installs some useful tools on a server.
basic_packages =
  value_for_platform_family(
    debian: %w(atsar vim locate apt-utils bsdutils htop tmux rsync iftop iotop telnet tcpdump strace sysstat ngrep),
    rhel: %w(vim mlocate tmux rsync iotop telnet tcpdump strace sysstat)
  )

basic_packages.each do |p|
  package p
end
