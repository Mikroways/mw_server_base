# Installs some useful tools on a server.
basic_packages =
  value_for_platform_family(
    debian: %w(atsar vim locate apt-utils bsdutils htop rsync iftop iotop telnet tcpdump strace sysstat ngrep tmux iproute haveged),
    rhel: %w(vim mlocate htop rsync iftop iotop telnet tcpdump strace sysstat ngrep tmux iproute haveged)
  )

basic_packages.each do |p|
  package p
end

include_recipe 'rsyslog'
include_recipe 'ntp'
