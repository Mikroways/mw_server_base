include_recipe 'chef-vault'

mail_config = node['mw_server_base']['postfix']

fail('Vault item must be specified to be able to setup mail server relay.') \
  unless mail_config['vault']['item']

# Get configuration data from vault (check README for an example).
data = chef_vault_item(mail_config['vault']['name'], mail_config['vault']['item'])

# Create base hashes if they don't exist.
node.set['postfix'] = {} unless node['postfix']
node.set['postfix']['main'] = {} unless node['postfix']['main']
node.set['postfix']['sasl'] = {} unless node['postfix']['sasl']

node.set['postfix']['main']['mydomain'] = '$myhostname'
node.set['postfix']['main']['relayhost'] = mw_server_base_relayhost(data['relayhost'], data['port'] || 25)
node.set['postfix']['sasl']['smtp_sasl_user_name'] = data['username'] if data['username']
node.set['postfix']['sasl']['smtp_sasl_passwd'] = data['password'] if data['password']
node.set['postfix']['aliases'] = data['aliases'] if data['aliases']

include_recipe 'postfix::default'
include_recipe 'postfix::aliases' if data['aliases']
