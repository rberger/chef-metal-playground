require 'chef/config'
require 'chef_metal'

with_chef_server "https://192.168.67.250", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}
