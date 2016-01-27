# Installs some useful tools on a server.
basic_packages =
  value_for_platform_family node['mw_server_base']['basic_packages']

basic_packages.each do |p|
  package p
end
