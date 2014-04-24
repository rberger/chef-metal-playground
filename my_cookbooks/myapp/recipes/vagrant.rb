# Cookbook Name:: myapp
# Recipe:: vagrant
#
# Copyright (C) 2014 Robert J. Berger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Include this recipe in your run list if you want to deploy to vagrant

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
