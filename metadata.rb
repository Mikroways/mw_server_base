name              'mw_server_base'
maintainer        'Leandro Di Tommaso'
maintainer_email  'leandro.ditommaso@mikroways.net'
license           'Apache 2.0'
description       'Cookbook to apply the minimal configuration we want to have on every server.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.1.0'
issues_url        'https://github.com/Mikroways/mw_server_base/issues' if respond_to?(:issues_url)
source_url        'https://github.com/Mikroways/mw_server_base' if respond_to?(:source_url)

supports          'centos'
supports          'debian'
supports          'ubuntu'

depends           'apt',              '~> 2.9.2'
depends           'chef-vault',       '~> 1.3.2'
depends           'fail2ban',         '~> 2.3.0'
depends           'locale',           '~> 1.0.3'
depends           'ntp',              '~> 1.10.0'
depends           'postfix',          '~> 5.0.1'
depends           'openssh',          '~> 1.6.1'
depends           'rsyslog',          '~> 4.0.0'
depends           'simple_iptables',  '~> 0.7.4'
depends           'sudo',             '~> 2.8.0'
depends           'timezone_lwrp',    '~> 0.1.7'
depends           'users',            '~> 2.0.2'
depends           'yum-epel',         '~> 0.6.5'
