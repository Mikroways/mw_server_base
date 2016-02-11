include_recipe 'users'

admin_groups = Array(node['mw_server_base']['authorization']['superadmin_group']) +
               Array(node['mw_server_base']['authorization']['additional_superadmin_group'])

admin_groups.each do |group|
  users_manage group
end

node.default['authorization']['sudo']['passwordless'] = node['mw_server_base']['authorization']['sudo']['passwordless']
node.default['authorization']['sudo']['include_sudoers_d'] = node['mw_server_base']['authorization']['sudo']['include_sudoers_d']
node.default['authorization']['sudo']['groups'] = admin_groups

include_recipe 'sudo'
