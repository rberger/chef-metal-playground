require 'cheffish'
require 'chef_metal_vagrant'
require 'chef/config'

repo_base = Chef::Config[:chef_repo_path]

# Set up a vagrant cluster (place for vms) in ~/machinetest
vagrant_cluster "#{repo_base}/machinetest"

directory "#{repo_base}/machinetest/repo"
#with_chef_local_server :chef_repo_path => "#{ENV['HOME']}/machinetest/repo"

vagrant_box 'opscode-ubuntu-13.04' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box'
end
