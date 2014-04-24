# Cookbook Name:: myapp
# Recipe:: chefserver.rb
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

# Include this reciepe if you want to use a real chef-server

require 'chef/config'
require 'chef_metal'

# Will get the chef server config from the knife.rb
with_chef_server Chef::Config[:chef_server_url], {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}
