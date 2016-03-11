node.set['simple_iptables']['ip_versions'] = %w(ipv4 ipv6)

package 'iptables-ipv6' if node['platform_family'] == 'rhel'

include_recipe 'simple_iptables'

## Firewall Rules
# Accept all localhost connections
simple_iptables_rule 'loopback' do
  direction 'INPUT'
  rule '-i lo'
  jump 'ACCEPT'
  weight 1
  ip_version :both
end

# Accept all established and related connections
simple_iptables_rule 'established' do
  direction 'INPUT'
  rule '-m state --state ESTABLISHED,RELATED'
  jump 'ACCEPT'
  weight 1
  ip_version :both
end

# Allow SSH
simple_iptables_rule 'ssh' do
  rule '--proto tcp --dport 22'
  jump 'ACCEPT'
  ip_version :both
end

# Sets default policy for INPUT and FORWARD chains.
simple_iptables_policy 'INPUT' do
  policy 'DROP'
  ip_version :both
end

simple_iptables_policy 'FORWARD' do
  policy 'DROP'
  ip_version :both
end
