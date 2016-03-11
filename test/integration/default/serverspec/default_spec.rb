require 'spec_helper'

describe 'mw_server_base::security' do
  describe iptables do
    it { should have_rule('-P INPUT DROP') }
    it { should have_rule('-P FORWARD DROP') }
    it { should have_rule('-P OUTPUT ACCEPT') }
  end

  if os[:family].include?('redhat') && Gem::Version.new(os[:release]) < Gem::Version.new("7")
    describe iptables do
      it { should have_rule('-A ssh -p tcp -m tcp --dport 22 -m comment --comment "ssh" -j ACCEPT').with_table('filter').with_chain('ssh') }
      it { should have_rule('-A established -m state --state RELATED,ESTABLISHED -m comment --comment "established" -j ACCEPT').with_table('filter').with_chain('established') }
      it { should have_rule('-A loopback -i lo -m comment --comment "loopback" -j ACCEPT').with_table('filter').with_chain('loopback') }
    end
  else
    describe iptables do
      it { should have_rule('-A ssh -p tcp -m tcp --dport 22 -m comment --comment ssh -j ACCEPT').with_table('filter').with_chain('ssh') }
      it { should have_rule('-A established -m state --state RELATED,ESTABLISHED -m comment --comment established -j ACCEPT').with_table('filter').with_chain('established') }
      it { should have_rule('-A loopback -i lo -m comment --comment loopback -j ACCEPT').with_table('filter').with_chain('loopback') }
    end
  end

  describe file('/bin/su') do
    it { should be_mode 4750 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'sysadmin' }
  end

  describe file('/etc/ssh/sshd_config') do
    it { should contain 'ChallengeResponseAuthentication no'}
    it { should contain 'MaxAuthTries 4' }
    it { should contain 'PasswordAuthentication no' }
    it { should contain 'PermitRootLogin without-password' }
    it { should contain 'PrintLastlog yes' }
    it { should contain 'PrintMotd no' }
    it { should contain 'PubkeyAuthentication yes' }
    it { should contain 'Subsystem sftp /usr/lib/openssh/sftp-server' }
    it { should contain 'TCPKeepAlive yes' }
    it { should contain 'UseDns no' }
    it { should contain 'UsePAM yes' }
    it { should contain 'UsePrivilegeSeparation yes' }
    it { should contain 'X11Forwarding no' }
  end

  describe service(service_name_for('ssh')) do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('fail2ban') do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'mw_server_base::setup - Debian Family Specifics' do
  if %w(debian ubuntu).include?(os[:family])
    describe package('apt') do
      it { should be_installed }
    end

    describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
      it { should contain "Unattended-Upgrade::Allowed-Origins {\n\"${distro_id} ${distro_codename}-security\";\n};" }
      it { should contain 'Unattended-Upgrade::Mail \"root@localhost\";' }
    end
  end
end

describe 'mw_server_base::setup - Timezone' do
  describe command('date +%Z') do
    its(:stdout) { should match "^ART\n$" }
  end
end

describe 'mw_server_base::basic_packages' do
  if %w(debian ubuntu).include?(os[:family])
    packages = %w(atsar vim locate apt-utils bsdutils htop rsync iftop iotop telnet tcpdump strace sysstat ngrep tmux iproute)
  elsif %w(centos redhat fedora).include?(os[:family])
    packages = %w(vim-enhanced mlocate htop rsync iftop iotop telnet tcpdump strace sysstat ngrep tmux iproute)
  end
  packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end

  describe process('rsyslogd') do
    it { should be_running }
  end

  # TODO: check NTP service.
end

describe 'mw_server_base::users' do
  describe user('car') do
    it { should exist }
    it { should belong_to_group 'additional_admin' }
  end

  describe user('leandro') do
    it { should exist }
    it { should belong_to_group 'sysadmin' }
  end

  describe user('dummy') do
    it { should_not exist }
  end

  describe file('/home/leandro/.ssh/authorized_keys') do
    it { should contain 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIkBbGX4uwWuiT4qFonk/0GGnDaiswoyqD/QZbrziEOQQCcpHH4EVHpr/Fd9tHQn3GDGARNDMhIYBLt4UaHelHqrVLDkbRnQlaG33VUq9H/ztwQXocfaCW4yjXMdVFQ5d4+u+252bXjG8vhQCaXdPKJXEnKOkpVxukSYys+Ig0uWir2oGf1tzEPwjODivBUbbF0M0/3CJdLVz2bkx4ABqNGRThmtCRhSpnmgNb+lDeX6ulLLRp8OIwGI2UsIdnKes8aroFB8hyHkXfnrYDqvKD59rWxkp8WG4FhtR40ePk5NmRgKcojfSDVfyOqZG2iC/JSaegBV46UbpU3yo9eu2x leandro@scarlett.local' }
  end

  describe file('/etc/sudoers') do
    it { should contain '%sysadmin ALL=(ALL) NOPASSWD:ALL' }
    it { should contain '%additional_admin ALL=(ALL) NOPASSWD:ALL' }
  end
end

describe 'mw_server_base::postfix' do
  describe mail_alias('abuse') do
    it { should be_aliased_to 'root' }
  end

  describe mail_alias('root') do
    it { should be_aliased_to 'soporte' }
  end

  describe file('/etc/postfix/main.cf') do
    it { should contain 'relayhost = [smtp.googlemail.com]:587' }
  end

  describe port(25) do
    it { should be_listening.on('127.0.0.1').with('tcp') }
  end

  describe service('postfix') do
    it { should be_enabled }
    it { should be_running }
  end
end
